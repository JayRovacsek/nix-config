# Declarative management of halogen-flash-server, the Qwen3.8-Flash-Next
# inference server for AMD Strix Halo. Two runtimes are supported: "oci"
# runs the pinned upstream image through virtualisation.oci-containers on the
# podman backend (the declarative migration of the loose docker-compose.yml),
# and "package" runs a nix-built halogen-flash-server binary directly via
# systemd. The module is self-sufficient: the oci runtime enables rootful
# podman itself and does not touch virtualisation.docker. Following the repo
# dragonwilds-server split, this options file holds both the declarations and
# the implementation; ../../modules/halogen-flash-server merely imports it
# and enables it.
#
# Upstream reference example (structure/idioms):
#   https://github.com/ruebenramirez/systems/blob/69c57554d15e3a8df42c7e89c196e76ad40c1975/nix/machines/fwai0/services/halogen-flash-server.nix
#
# Rationale: manage the server declaratively via NixOS rather than an
# ad-hoc compose file (supply-chain documentation per repo policy).
{
  config,
  lib,
  pkgs,
  self,
  ...
}:
with lib;
let
  cfg = config.services.halogen-flash-server;

  # The engine always reads its lookup table as qwen38-flash-next-ngram.hgn
  # beside the checkpoint, whatever the checkpoint is called (docs/FLAGS.md);
  # the name is not a supported flag, so it stays a constant here rather than
  # an option.
  lookupTable = "qwen38-flash-next-ngram.hgn";

  # The oci runtime mounts modelDir/cacheDir at fixed in-container paths and
  # publishes the API on containerPort (mapped to hostAddress:hostPort); the
  # package runtime runs the binary on the host, so the same values are
  # referenced directly.
  modelsPrefix = if cfg.runtime == "oci" then "/models" else cfg.modelDir;
  cachePrefix = if cfg.runtime == "oci" then "/cache" else cfg.cacheDir;
  apiPort = if cfg.runtime == "oci" then cfg.containerPort else cfg.hostPort;

  defaultEnvironment = {
    HALOGEN_API_PORT = toString apiPort;
    HALOGEN_KV_SLOTS = "3"; # conversations generating at once (~115 MB each)
    HALOGEN_REASONING_EFFORT = "low"; # unset == the template's xhigh
    HALOGEN_MAX_TOKENS_DEFAULT = "32768"; # budget when a request sends none (hard cap 65536)
    HALOGEN_CACHE_DIR = cachePrefix;
    HALOGEN_CACHE_DISK_GIB = "64";
    HALOGEN_CACHE_PRUNE_OLD = "1"; # else every upgrade leaves a 30-60 GB subtree behind
    # Codified from checkpointFile: the oci runtime mounts modelDir read-only
    # at /models, so the file name interpolates under that prefix; the package
    # runtime reads it from modelDir directly. Set explicitly rather than left
    # to the engine's default so it can never drift from the artefact the
    # validation units gate on.
    HALOGEN_CHECKPOINT = "${modelsPrefix}/${cfg.checkpointFile}";
  }
  // lib.optionalAttrs cfg.enableVision {
    # Path form of the flag (the engine also accepts `1` to auto-discover the
    # file beside the checkpoint); interpolated so it can never drift from the
    # validated artefact.
    HALOGEN_VISION_TOWER = "${modelsPrefix}/${cfg.visionFile}";
  };

  # Gates the server unit: catches empty/partial `hf download` results before
  # the engine starts. Complements the service unit's AssertPathExists
  # (existence only) by also failing on zero-byte artefacts and logging each
  # file's size for the record. The vision file is validated only when
  # enableVision is set — text-only hosts must not be blocked by it.
  requiredArtefacts = [
    "${cfg.modelDir}/${cfg.checkpointFile}"
    "${cfg.modelDir}/${lookupTable}"
  ]
  ++ lib.optionals cfg.enableVision [ "${cfg.modelDir}/${cfg.visionFile}" ];

  # The hint's exclude globs skip the stock repo's superseded w4b and
  # experimental ht43 checkpoints (tens of GB each); they match nothing on
  # derivative repos, which is harmless. Derivatives may also need companion
  # files from a different repo — see modelRepo.
  validateScript = pkgs.writeShellScript "halogen-flash-server-validate" ''
    set -euo pipefail
    echo "halogen: pinned model revision: ${cfg.modelRevision}"
    for f in ${lib.escapeShellArgs requiredArtefacts}; do
      if [ ! -s "$f" ]; then
        echo "halogen: missing or empty model artefact: $f" >&2
        echo "halogen: e.g. pull with: hf download ${cfg.modelRepo} --revision ${cfg.modelRevision} --local-dir ${cfg.modelDir} --exclude 'qwen38-flash-next-w4b*' --exclude '*ht43*'" >&2
        exit 1
      fi
      echo "halogen: $f is $(stat -c %s "$f") bytes"
    done
  '';

  # The unit the validate oneshot gates, per runtime: the podman backend
  # prefixes container units with "podman-"; the package runtime's unit is
  # the systemd service defined below.
  serverUnit =
    if cfg.runtime == "oci" then
      "podman-halogen-flash-server.service"
    else
      "halogen-flash-server.service";
in
{
  # The reusable Strix Halo tuning baseline is imported unconditionally so its
  # options are always declared; its config is gated by hardware.strix-halo
  # .enable below (the module system forbids referencing config in imports,
  # so a conditional import is not possible).
  imports = [ ../hardware/strix-halo ];

  options.services.halogen-flash-server = {
    enable = mkEnableOption "halogen-flash-server inference server";

    runtime = mkOption {
      type = types.enum [
        "oci"
        "package"
      ];
      default = "oci";
      description = ''
        How the server is delivered: "oci" runs the pinned container image
        through virtualisation.oci-containers (podman); "package" runs a
        nix-built halogen-flash-server binary directly via systemd.
      '';
    };

    package = mkOption {
      type = types.package;
      default = self.packages.${pkgs.system}.halogen-flash-server;
      defaultText = literalExpression "self.packages.\${pkgs.system}.halogen-flash-server";
      description = ''
        The halogen-flash-server package to run when runtime is "package".
        Defaults to this flake's own package; set to any derivation providing
        bin/halogen-flash-server to serve a different build. Unused by the
        "oci" runtime.
      '';
    };

    version = mkOption {
      type = types.str;
      # Pin exactly; never :latest. Follows the package's version so the
      # image tag and the vendored package can never drift apart; override
      # to pin the image to a different release.
      default = cfg.package.version;
      defaultText = literalExpression "cfg.package.version";
      description = "Version of the halogen-flash-server container image (oci runtime only).";
    };

    modelRepo = mkOption {
      type = types.str;
      default = "peonist-ai/halogen-qwen3.8-flash-next";
      description = ''
        Hugging Face repository the model artefacts are pulled from; recorded
        in the validation hint. Derivative checkpoints may publish only their
        own checkpoint and still take the lookup table, tokenizer and vision
        tower from peonist's repository — check the derivative's model card
        and pull each companion file from its stated source.
      '';
    };

    modelRevision = mkOption {
      type = types.str;
      default = "647e3814953e8435d58f5d5aa13b97aca85a7d93";
      description = ''
        Pinned Hugging Face revision of modelRepo carrying the checkpoint and
        lookup table, recorded so the model pull can be validated and
        reproduced.
      '';
    };

    checkpointFile = mkOption {
      type = types.str;
      default = "qwen38-flash-next-v2.hgn";
      description = ''
        Checkpoint file name within modelDir. Served to the engine as
        HALOGEN_CHECKPOINT=/models/<name>; the engine's own default matches
        the stock v2 file, so pointing this at a derivative's file name is
        how that derivative gets served instead. The validation artefacts
        assume the v2 layout (checkpoint + n-gram table); the older w4b
        checkpoint additionally needs a <name>.overlay.hgn sidecar and is
        not covered by these checks.
      '';
    };

    visionFile = mkOption {
      type = types.str;
      default = "qwen38-flash-next-vision.hgn";
      description = ''
        Vision tower file name within modelDir. Served as
        HALOGEN_VISION_TOWER=/models/<name> when enableVision is set.
      '';
    };

    enableVision = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable the optional vision tower (the file named by visionFile) so
        the server can read images. When false the server is text-only; text
        behaviour is byte-identical either way. The vision file must be pulled
        beside the checkpoint when this is enabled.
      '';
    };

    applyRecommendedSystemSettings = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Import the reusable hardware/strix-halo tuning baseline (kernel
        params + ROCm env) alongside the engine.
      '';
    };

    modelDir = mkOption {
      type = types.str;
      default = "/srv/halogen-models";
      description = "Host directory holding the model weights, mounted read-only at /models by the oci runtime.";
    };

    cacheDir = mkOption {
      type = types.str;
      default = "/srv/halogen-cache";
      description = "Host directory for the on-disk KV cache, mounted at /cache by the oci runtime.";
    };

    hostAddress = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = ''
        Address to bind the published port on (oci runtime only). The API has
        no auth of its own, so the network is the access control — keep this
        loopback-bound. The package runtime's API always binds 0.0.0.0
        (serve_api.py hardcodes --host 0.0.0.0), so restrict access with the
        firewall when using it.
      '';
    };

    hostPort = mkOption {
      type = types.port;
      default = 11435;
      description = "Host port the API is published on.";
    };

    containerPort = mkOption {
      type = types.port;
      default = 8731;
      description = "Port the server listens on inside the container (oci runtime only).";
    };

    extraEnvironment = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Extra HALOGEN_* environment variables, merged over the defaults.";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      # Runtime-independent settings.
      {
        # Activate the reusable Strix Halo tuning baseline (kernel params + ROCm
        # env) unless opted out. mkDefault so a host can still flip it directly.
        hardware.strix-halo.enable = lib.mkDefault cfg.applyRecommendedSystemSettings;

        # Codifies the blog's manual `mkdir -p` layout. NOTE: the cache dir must
        # live on a real filesystem that supports direct I/O — a tmpfs or the
        # container overlay is refused and the disk cache silently stays
        # memory-only. tmpfiles therefore only creates the mountpoint dir; the
        # real filesystem behind ${cfg.cacheDir} is a host-level concern.
        systemd.tmpfiles.rules = [
          "d ${cfg.modelDir} 0755 root root - -"
          "d ${cfg.cacheDir} 0755 root root - -"
        ];

        # Records the pinned HF revision so the model pull can be validated and
        # reproduced (mirrors the upstream reference example).
        environment.etc."halogen/model-revision".text = "${cfg.modelRevision}\n";
        # Keeps the `hf` downloader available for explicit, revision-pinned
        # re-pulls: hf download peonist-ai/halogen-qwen3.8-flash-next ...
        environment.systemPackages = [ pkgs.python3Packages.huggingface-hub ];

        # Gates the server unit: fails activation early if the pinned model
        # artefacts are missing or truncated (see validateScript above).
        systemd.services.halogen-flash-server-validate = {
          description = "Validate halogen-flash-server model artefacts";
          after = [ "local-fs.target" ];
          wants = [ "local-fs.target" ];
          before = [ serverUnit ];
          requiredBy = [ serverUnit ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${validateScript}";
          };
        };
      }

      # The oci runtime: rootful podman driving the pinned container.
      (lib.mkIf (cfg.runtime == "oci") {
        # Rootful podman is what the oci-containers podman backend drives.
        virtualisation.podman.enable = true;

        virtualisation.oci-containers.backend = "podman";

        virtualisation.oci-containers.containers.halogen-flash-server = {
          # Pin exactly; never :latest.
          # TODO: follow up with a @sha256: digest pin for full supply-chain
          # reproducibility — it would append to the interpolated image below
          # (do not fabricate one — resolve it from the registry).
          image = "ghcr.io/peonist-ai/halogen-flash-server:${cfg.version}";
          # Pulled in by podman.service at boot, so the container survives host
          # reboots — this replaces the blog's manual halogen-stack.service
          # oneshot (plain docker `restart: unless-stopped` did not: the engine
          # exits rc=1 on takedown and docker treats it as stopped).
          autoStart = true;
          podman.sdnotify = "healthy";
          environment = defaultEnvironment // cfg.extraEnvironment;
          volumes = [
            "${cfg.modelDir}:/models:ro"
            "${cfg.cacheDir}:/cache"
          ];
          devices = [
            "/dev/kfd:/dev/kfd"
            "/dev/dri:/dev/dri"
          ];
          # NEVER bind 0.0.0.0 — the API has no auth, so the loopback binding is
          # the access control. Deliberately no firewall rules: nothing should be
          # reachable beyond the loopback interface.
          ports = [ "${cfg.hostAddress}:${toString cfg.hostPort}:${toString cfg.containerPort}" ];
          extraOptions = [
            # Lets a container that survived a unit restart be replaced instead
            # of wedging the fixed container name.
            "--replace"
            "--ipc=host"
            # Locked weights; the mmap/lock fails without this.
            "--ulimit"
            "memlock=-1:-1"
            # Matches upstream's every-invocation flag set; ROCm kfd ioctls trip
            # the default seccomp profile.
            "--security-opt"
            "seccomp=unconfined"
            # keep-groups is a Podman keyword: it inherits the host's
            # supplementary groups (video/render) into the container. The
            # numeric GIDs the compose file needed (39/105) were a Docker-only
            # workaround — docker resolves group NAMES against the container's
            # /etc/group, which has neither.
            "--group-add"
            "keep-groups"
            # Readiness ("model is ready") is observed via GET /health; the
            # healthcheck wires podman's sdnotify so the unit reports healthy
            # (faithful to the upstream reference example).
            "--health-cmd=/usr/local/bin/halogen-healthcheck auto"
            "--health-interval=30s"
            "--health-on-failure=kill"
            "--health-retries=3"
            "--health-start-period=45m"
            "--health-timeout=35s"
          ];
        };

        # The podman backend prefixes container units with "podman-".
        systemd.services.podman-halogen-flash-server = {
          # llama-cpp and halogen are both memory-heavy on the 128 GiB
          # unified-memory Strix Halo box and must be mutually exclusive.
          conflicts = [ "llama-cpp.service" ];
          # Same artefact list the validate oneshot gates on (existence only;
          # the oneshot adds the non-empty check).
          unitConfig.AssertPathExists = requiredArtefacts;
          unitConfig.RequiresMountsFor = [ cfg.modelDir ];
          serviceConfig = {
            LimitMEMLOCK = "infinity";
            RestartSec = "10s";
            # Compose stop_grace_period: the disk cache writes each turn's rows
            # behind the request, so give shutdown time to flush. mkForce because
            # oci-containers sets TimeoutStopSec = 120 itself.
            TimeoutStopSec = lib.mkForce "60s";
          };
        };
      })

      # The package runtime: the nix-built binary run directly by systemd.
      (lib.mkIf (cfg.runtime == "package") {
        systemd.services.halogen-flash-server = {
          description = "halogen-flash-server inference server";
          after = [ "network.target" ];
          # llama-cpp and halogen are both memory-heavy on the 128 GiB
          # unified-memory Strix Halo box and must be mutually exclusive.
          conflicts = [ "llama-cpp.service" ];
          # Same artefact list the validate oneshot gates on (existence only;
          # the oneshot adds the non-empty check).
          unitConfig.AssertPathExists = requiredArtefacts;
          unitConfig.RequiresMountsFor = [ cfg.modelDir ];
          serviceConfig = {
            # The wrapper defaults to mode "all" (engine + API).
            ExecStart = "${cfg.package}/bin/halogen-flash-server";
            Environment = mapAttrsToList (k: v: "${k}=${v}") (defaultEnvironment // cfg.extraEnvironment);
            # Locked weights; the mmap/lock fails without this (the 8 MiB
            # systemd default is what forces manual `sudo` runs).
            LimitMEMLOCK = "infinity";
            # The engine exits rc=1 on takedown, so restart unconditionally
            # (plain docker `restart: unless-stopped` treated that as stopped).
            Restart = "always";
            RestartSec = "10s";
            # Compose stop_grace_period: the disk cache writes each turn's rows
            # behind the request, so give shutdown time to flush.
            TimeoutStopSec = "60s";
          };
        };
      })
    ]
  );
}
