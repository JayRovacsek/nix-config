{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption types;
  inherit (pkgs.stdenv.hostPlatform) system;

  # A document is either a file (Nix path or store path string) or an inline
  # attribute set. Files are read at build time, never at evaluation time.
  document =
    with types;
    oneOf [
      path
      str
      (attrsOf anything)
    ];

  # A single sandbox: every `openshell sandbox create` flag, declared
  # declaratively. The attribute name is the sandbox name (a DNS-1123
  # label, as required by the Kubernetes driver).
  sandbox = types.submodule (
    { name, config, ... }: {
      options = {
        assertions = mkOption {
          type = types.assertions;
          default = [ ];
          description = "Additional assertions that must hold for this sandbox.";
        };

        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Whether this sandbox should exist on its gateway; setting it to false deletes the sandbox from the gateway.";
        };

        image = mkOption {
          type = types.str;
          default = "nixpkgs/nix-flakes";
          description = "Base image (`--from`). Ignored when `template` is set.";
        };

        template = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            Create from a named sandbox workload template (`--template`)
            instead of an inline workload. When set, `image`, `cpu`,
            `memory`, `gpu`, `env` and `driverConfigJson` are not passed
            to `sandbox create`.
          '';
        };

        command = mkOption {
          type = types.listOf types.str;
          default = [ "opencode" ];
          example = [
            "nix"
            "run"
            "nixpkgs#opencode"
          ];
          description = ''
            Canonical main process (the trailing `-- <COMMAND>...`).
            Defaults to `opencode`. Use `[ ]` for the image's default
            shell; `[ ]` is also required when `upload` is set (the CLI
            rejects uploads with a trailing command).
          '';
        };

        providers = mkOption {
          type = types.listOf types.str;
          default = [ ];
          example = [
            "halogen-server"
            "github"
          ];
          description = "Provider instances to attach (`--provider`, repeatable).";
        };

        autoProviders = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Auto-create missing provider instances from local credentials
            (`--auto-providers` / `--no-auto-providers`). Needed for
            non-interactive creation of providers whose instances do not
            exist yet.
          '';
        };

        policy = mkOption {
          type = types.nullOr document;
          default = null;
          description = ''
            Sandbox policy (`--policy`). When null, the gateway-wide
            `OPENSHELL_SANDBOX_POLICY` applies. Checked against
            `boundaryPolicy` at build time when set.
          '';
        };

        labels = mkOption {
          type = types.attrsOf types.str;
          default = { };
          example = {
            tier = "limited";
          };
          description = ''
            Labels (`--label`, repeatable). The module also adds a
            `nix-config-spec` label holding the hash of the rendered
            create arguments so spec changes can be detected.
          '';
        };

        env = mkOption {
          type = types.attrsOf types.str;
          default = { };
          description = "Non-secret environment variables (`--env`, repeatable).";
        };

        noCredentialWarnings = mkOption {
          type = types.bool;
          default = false;
          description = "Suppress credential-looking `--env` warnings (`--no-credential-warnings`).";
        };

        cpu = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "2";
          description = "CPU limit (`--cpu`), Kubernetes-style quantity (500m, 1, 2.5).";
        };

        memory = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "4Gi";
          description = "Memory limit (`--memory`), byte quantity (512Mi, 4Gi, 8G).";
        };

        gpu = mkOption {
          type = types.nullOr (
            types.oneOf [
              types.bool
              types.ints.positive
            ]
          );
          default = null;
          example = 1;
          description = ''
            GPU request (`--gpu [COUNT]`). `true` requests the driver's
            default selection; an integer requests that many GPUs.
          '';
        };

        driverConfigJson = mkOption {
          type = types.nullOr (
            types.oneOf [
              types.str
              (types.attrsOf types.anything)
            ]
          );
          default = null;
          example = {
            docker = {
              cdi_devices = [ "nvidia.com/gpu=0" ];
            };
          };
          description = ''
            Driver-keyed settings (`--driver-config-json`). Attribute sets
            are serialised with `builtins.toJSON`; strings are passed
            verbatim as inline JSON. Requires `allow_driver_config` on
            the gateway.
          '';
        };

        restartPolicy = mkOption {
          type = types.enum [
            "never"
            "on-failure"
            "always"
          ];
          default = "never";
          description = "Main-process restart behaviour (`--restart-policy`).";
        };

        detach = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Create without attaching (`--detach`). The load service runs
            non-interactively; `false` blocks it until the main process
            exits and suits only short-lived commands.
          '';
        };

        noKeep = mkOption {
          type = types.bool;
          default = false;
          description = "Delete the sandbox once the main process exits (`--no-keep`).";
        };

        editor = mkOption {
          type = types.nullOr (
            types.enum [
              "vscode"
              "cursor"
            ]
          );
          default = null;
          description = "Remote editor to launch after creation (`--editor`).";
        };

        forward = mkOption {
          type = types.listOf types.str;
          default = [ ];
          example = [
            "8080"
            "0.0.0.0:3000"
          ];
          description = "Local port forwards (`--forward [BIND_ADDRESS:]PORT`, repeatable).";
        };

        expose = mkOption {
          type = types.nullOr types.port;
          default = null;
          description = "Expose the unnamed HTTP/WebSocket service on this port (`--expose`).";
        };

        exposeAuthorizationMode = mkOption {
          type = types.enum [
            "strip"
            "bearer-passthrough"
          ];
          default = "strip";
          description = "Authorization handling for the exposed service (`--expose-authorization-mode`), only applied when `expose` is set.";
        };

        upload = mkOption {
          type = types.listOf (types.either types.path types.str);
          default = [ ];
          example = [ "./config.json:/workspace/config.json" ];
          description = ''
            Local files to upload (`--upload PATH[:DEST]`, repeatable).
            Paths are copied into the Nix store; strings are passed
            verbatim and may carry an explicit `:DEST`. A bare path
            lands in the sandbox under its store basename
            (`<hash>-name`), so prefer the string form with an explicit
            `:DEST` to control the destination name. Requires
            `command = [ ]` (the CLI rejects uploads with a trailing
            command).
          '';
        };

        noGitIgnore = mkOption {
          type = types.bool;
          default = false;
          description = "Disable `.gitignore` filtering for uploads (`--no-git-ignore`).";
        };

        approvalMode = mkOption {
          type = types.enum [
            "manual"
            "auto"
          ];
          default = "manual";
          description = "Handling of agent-authored policy proposals (`--approval-mode`).";
        };
      };

      config = {
        assertions = [
          {
            assertion = config.upload == [ ] || config.command == [ ];
            message = "sandbox '${name}': `upload` cannot be combined with a trailing `command`; set `command = [ ]` to use uploads.";
          }
          {
            assertion = !(config.labels ? "nix-config-spec");
            message = "sandbox '${name}': the `nix-config-spec` label is reserved by the module for spec tracking; remove it from `labels`.";
          }
          {
            assertion =
              !config.noKeep || (config.forward == [ ] && config.expose == null && config.editor == null);
            message = "sandbox '${name}': `noKeep` deletes the sandbox once the main process exits, which conflicts with `forward`, `expose` and `editor` (they keep the sandbox alive).";
          }
          {
            assertion =
              config.template == null
              || (
                config.cpu == null
                && config.memory == null
                && config.gpu == null
                && config.env == { }
                && config.driverConfigJson == null
              );
            message = "sandbox '${name}': `template` replaces the inline workload fields `cpu`, `memory`, `gpu`, `env` and `driverConfigJson`; unset them.";
          }
        ];
      };
    }
  );

  gateway = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        description = ''
          Gateway name. Entries sharing a name are merged into one gateway,
          each name runs as its own service.
        '';
      };

      settings = mkOption {
        type = (pkgs.formats.toml { }).type;
        default = { };
        description = ''
          Gateway TOML configuration, rooted at the top level of the file
          (i.e. `openshell.gateway.*`, `openshell.drivers.*`).
          See https://docs.nvidia.com/openshell/latest/how-it-works/gateways/configuration
        '';
      };

      environment = mkOption {
        type = types.attrsOf types.str;
        default = { };
        example = {
          DOCKER_HOST = "unix:///Users/me/.colima/default/docker.sock";
        };
        description = "Environment variables for the gateway process.";
      };

      sandboxes = mkOption {
        type = types.attrsOf sandbox;
        default = { };
        example = lib.literalExpression ''
          {
            # Minimal: defaults give the nixpkgs/nix-flakes image running
            # opencode, attached to one provider.
            ai-locked = {
              providers = [ "halogen-server" ];
              policy = ./profiles/locked.yaml;
            };

            # Every option set explicitly (except `template`, which
            # replaces the inline workload fields shown above):
            ai-full = {
              image = "nixpkgs/nix-flakes";
              command = [ "opencode" ];
              providers = [ "halogen-server" "github" ];
              autoProviders = true;
              policy = ./profiles/limited.yaml;
              labels = { tier = "limited"; };
              env = { FEATURE_FLAG = "on"; };
              noCredentialWarnings = false;
              cpu = "2";
              memory = "4Gi";
              gpu = 1;
              driverConfigJson = { docker = { cdi_devices = [ "nvidia.com/gpu=0" ]; }; };
              restartPolicy = "on-failure";
              detach = true;
              noKeep = false;
              editor = "vscode";
              forward = [ "8080" ];
              expose = 8080;
              exposeAuthorizationMode = "bearer-passthrough";
              upload = [ ];
              noGitIgnore = false;
              approvalMode = "auto";
            };

            # Template-based: the workload shape comes from a named
            # sandbox template; uploads require an empty command.
            ai-template = {
              template = "gpu-kata";
              providers = [ "halogen-server" ];
              command = [ ];
              upload = [ "./config.json:/workspace/config.json" ];
              noGitIgnore = true;
              noKeep = true;
            };
          }
        '';
        description = ''
          Sandboxes managed on this gateway, keyed by sandbox name (a
          DNS-1123 label). The load service creates missing sandboxes
          (detached), recreates ones whose rendered spec changed, and
          deletes sandboxes that are no longer declared. Each enabled
          sandbox also gains a generated wrapper command named after it.
        '';
      };
    };
  };
  inherit (lib)
    foldl'
    groupBy
    mapAttrs
    mkIf
    mkMerge
    optionalAttrs
    recursiveUpdate
    ;

  cfg = config.services.openshell;
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;

  bin = "${cfg.package}/bin";
  yq = "${pkgs.yq-go}/bin/yq";
  jq = "${pkgs.jq}/bin/jq";

  # Inline attribute sets become JSON files (valid YAML), files pass through.
  toFile =
    name: document:
    if builtins.isAttrs document then
      pkgs.writeText "${name}.json" (builtins.toJSON document)
    else
      "${document}";

  toFiles = name: map (toFile name);

  # Deep merge all documents into one, later documents win.
  mergeDocuments =
    name: documents:
    pkgs.runCommand "${name}.json" { } ''
      ${yq} -o json -I0 '.' ${toString (toFiles name documents)} \
        | ${jq} -s 'reduce .[] as $x ({}; . * $x)' > $out
    '';

  # Fail the build if a policy exceeds the configured boundary.
  proveWithinBoundary =
    name: policy:
    if cfg.boundaryPolicy == null then
      policy
    else
      pkgs.runCommand "${name}-proven.json" { } ''
        ${bin}/openshell-prover check --boundary ${toFile "boundary" cfg.boundaryPolicy} ${policy}
        cp ${policy} $out
      '';

  # One file per provider id, deep merged so later entries win.
  providersDir = pkgs.runCommand "openshell-providers" { } ''
    mkdir -p $out
    ${lib.optionalString (cfg.providers != [ ]) ''
      ${yq} -o json -I0 '.' ${toString (toFiles "provider" cfg.providers)} \
        | ${jq} -sc 'group_by(.id) | map(reduce .[] as $x ({}; . * $x)) | .[]' \
        | while read -r profile; do
            id="$(echo "$profile" | ${jq} -r '.id')"
            echo "$profile" > "$out/$id.yaml"
          done
    ''}
  '';

  sandboxPolicy = proveWithinBoundary "openshell-sandbox-policy" (
    mergeDocuments "openshell-sandbox-policy" cfg.policies
  );

  globalPolicy =
    if cfg.globalPolicy == null then
      null
    else
      proveWithinBoundary "openshell-global-policy" (toFile "openshell-global-policy" cfg.globalPolicy);

  # Merge gateway entries by name, later entries win.
  gateways = mapAttrs (
    name: entries:
    foldl' recursiveUpdate {
      settings.openshell = {
        version = 2;
        gateway = {
          inherit name;
          bind_address = "127.0.0.1:17670";
          compute_driver = "docker";
          disable_tls = true;
          auth.allow_unauthenticated_users = true;
        };
      };
      environment = { };
    } (map (entry: removeAttrs entry [ "name" ]) entries)
  ) (groupBy (entry: entry.name) cfg.gateways);

  endpoint = gateway: "http://${gateway.settings.openshell.gateway.bind_address}";

  # Label recording the rendered create-args hash on each managed sandbox,
  # so spec changes can be detected on existing sandboxes (v0.1.3 has no
  # user-settable annotations).
  sandboxSpecLabel = "nix-config-spec";

  # The full `openshell sandbox create` argument list for one sandbox,
  # minus the spec label (whose value is the hash of these arguments).
  sandboxBaseArgs =
    name: s:
    [
      "sandbox"
      "create"
      "--name"
      name
    ]
    ++ lib.optionals (s.template == null) (
      [
        "--from"
        s.image
      ]
      ++ lib.optionals (s.cpu != null) [
        "--cpu"
        s.cpu
      ]
      ++ lib.optionals (s.memory != null) [
        "--memory"
        s.memory
      ]
      ++ lib.optionals (s.gpu != null) (
        if s.gpu == true then [ "--gpu" ] else [ "--gpu=${toString s.gpu}" ]
      )
      ++ lib.optionals (s.driverConfigJson != null) [
        "--driver-config-json"
        (
          if builtins.isAttrs s.driverConfigJson then
            builtins.toJSON s.driverConfigJson
          else
            s.driverConfigJson
        )
      ]
      ++ lib.mapAttrsToList (k: v: "--env=${k}=${v}") s.env
    )
    ++ lib.optionals (s.template != null) [
      "--template"
      s.template
    ]
    ++ map (p: "--provider=${p}") s.providers
    ++ [ (if s.autoProviders then "--auto-providers" else "--no-auto-providers") ]
    ++ lib.optionals (s.policy != null) [
      "--policy"
      (proveWithinBoundary "sandbox-${name}-policy" (toFile "sandbox-${name}-policy" s.policy))
    ]
    ++ lib.mapAttrsToList (k: v: "--label=${k}=${v}") s.labels
    ++ lib.optionals s.noCredentialWarnings [ "--no-credential-warnings" ]
    ++ [ "--restart-policy=${s.restartPolicy}" ]
    ++ lib.optionals s.detach [ "--detach" ]
    ++ lib.optionals s.noKeep [ "--no-keep" ]
    ++ lib.optionals (s.editor != null) [
      "--editor"
      s.editor
    ]
    ++ map (f: "--forward=${f}") s.forward
    ++ lib.optionals (s.expose != null) [
      "--expose=${toString s.expose}"
      "--expose-authorization-mode=${s.exposeAuthorizationMode}"
    ]
    ++ map (u: "--upload=${toString u}") s.upload
    ++ lib.optionals s.noGitIgnore [ "--no-git-ignore" ]
    ++ [ "--approval-mode=${s.approvalMode}" ];

  # The trailing `-- <COMMAND>` part; empty when using the image's default
  # shell. Kept separate because everything after `--` is parsed as the
  # main command's arguments, never as flags.
  sandboxCommandTail = s: lib.optionals (s.command != [ ]) ([ "--" ] ++ s.command);

  sandboxSpecHash =
    name: s:
    lib.substring 0 12 (
      builtins.hashString "sha256" (builtins.toJSON (sandboxBaseArgs name s ++ sandboxCommandTail s))
    );

  # The spec label goes before the `--` separator so it is parsed as a
  # flag, while the command stays last.
  sandboxCreateArgs =
    name: s:
    sandboxBaseArgs name s
    ++ [ "--label=${sandboxSpecLabel}=${sandboxSpecHash name s}" ]
    ++ sandboxCommandTail s;

  # Per-sandbox agent wrapper: starts the sandbox if needed and attaches
  # to its canonical main process (the agent session).
  mkSandboxCommand =
    gatewayName: sandboxName:
    pkgs.writeShellScriptBin sandboxName ''
      set -euo pipefail
      export OPENSHELL_GATEWAY_ENDPOINT=${lib.escapeShellArg (endpoint gateways.${gatewayName})}
      if ! ${bin}/openshell sandbox get ${lib.escapeShellArg sandboxName} >/dev/null 2>&1; then
        echo "error: sandbox '${sandboxName}' is not present on gateway '${gatewayName}' (has home-manager been activated?)" >&2
        exit 1
      fi
      ${bin}/openshell sandbox start ${lib.escapeShellArg sandboxName} >/dev/null 2>&1 || true
      exec ${bin}/openshell sandbox connect ${lib.escapeShellArg sandboxName}
    '';

  sandboxCommands = lib.concatMap (
    gatewayName:
    lib.mapAttrsToList (sandboxName: s: mkSandboxCommand gatewayName sandboxName) (
      lib.filterAttrs (_: s: s.enable) gateways.${gatewayName}.sandboxes
    )
  ) (lib.attrNames gateways);

  # Bash that converges one gateway's sandboxes onto the declared set:
  # delete undeclared sandboxes, recreate declared ones whose spec label
  # changed, and create missing ones.
  sandboxSyncScript =
    gatewayName: gateway:
    let
      enabled = lib.filterAttrs (_: s: s.enable) gateway.sandboxes;
      declaredNames = lib.concatStringsSep " " (lib.attrNames enabled);
      sandboxBlock =
        sandboxName: s:
        let
          args = lib.escapeShellArgs (sandboxCreateArgs sandboxName s);
          nameArg = lib.escapeShellArg sandboxName;
          specArg = lib.escapeShellArg (sandboxSpecHash sandboxName s);
        in
        ''
          if ! printf '%s\n' "$existing" | grep -Fxq ${nameArg}; then
            "$openshell" ${args} >/dev/null
          else
            info="$( "$openshell" sandbox get ${nameArg} --output json 2>/dev/null || true )"
            label="$(printf '%s' "$info" | ${jq} -r '.labels["${sandboxSpecLabel}"] // ""' 2>/dev/null || true)"
            phase="$(printf '%s' "$info" | ${jq} -r '.phase // ""' 2>/dev/null || true)"
            if [ "$label" != ${specArg} ] || [ "$phase" = "Error" ]; then
              "$openshell" sandbox delete ${nameArg} >/dev/null 2>&1 || true
              for ((i = 0; i < 60; i++)); do
                "$openshell" sandbox get ${nameArg} >/dev/null 2>&1 || break
                sleep 1
              done
              "$openshell" ${args} >/dev/null
            fi
          fi
        '';
    in
    ''
      # --- sandboxes: converge the gateway's set onto the declared set ---
      existing="$( "$openshell" sandbox list --output json | ${jq} -r '.sandboxes // [] | .[].name' )"
      for name in $existing; do
        case " ${declaredNames} " in
          *" $name "*) : ;;
          *) "$openshell" sandbox delete "$name" >/dev/null 2>&1 || true ;;
        esac
      done

      ${lib.concatStringsSep "\n" (lib.mapAttrsToList sandboxBlock enabled)}
    '';

  # Validated at build time, without starting the gateway.
  gatewayConfig =
    name: gateway:
    let
      file = (pkgs.formats.toml { }).generate "openshell-gateway-${name}.toml" gateway.settings;
    in
    pkgs.runCommand "openshell-gateway-${name}.toml" { } ''
      HOME="$TMPDIR" ${bin}/openshell-gateway --config ${file} config preflight
      cp ${file} $out
    '';

  gatewayEnvironment =
    name: gateway:
    {
      # Keep each gateway's database separate.
      XDG_STATE_HOME = "${config.xdg.stateHome}/openshell/gateways/${name}";
    }
    // gateway.environment;

  gatewayCommand = name: gateway: [
    "${pkgs.writeShellScript "openshell-gateway-${name}" ''
      set -euo pipefail
      # Sandbox launch signing keys (and local PKI), generated once per gateway
      # as upstream's packaged service does; existing files are left as-is.
      ${bin}/openshell-gateway generate-certs \
        --output-dir "$XDG_STATE_HOME/openshell/tls" \
        --server-san host.openshell.internal
      exec ${bin}/openshell-gateway --config ${gatewayConfig name gateway}
    ''}"
  ];

  # Reconcile the gateway database with the declared providers, policy and
  # sandboxes.
  loadScript =
    name: gateway:
    pkgs.writeShellScript "openshell-load-${name}" ''
      set -euo pipefail
      export OPENSHELL_GATEWAY_ENDPOINT=${lib.escapeShellArg (endpoint gateway)}
      openshell=${bin}/openshell

      for ((i = 0; i < 120; i++)); do
        "$openshell" status >/dev/null 2>&1 && break
        sleep 1
      done

      "$openshell" provider profile list --global -o json \
        | ${jq} -r '.[].id' \
        | while read -r id; do
            "$openshell" provider profile delete --global "$id"
          done

      ${lib.optionalString (cfg.providers != [ ]) ''
        "$openshell" provider profile import --global --from ${providersDir}
      ''}

      ${
        if globalPolicy == null then
          ''"$openshell" policy delete --global --yes''
        else
          ''"$openshell" policy set --global --yes --policy ${globalPolicy}''
      }

      ${lib.optionalString (gateway.sandboxes != { }) (sandboxSyncScript name gateway)}
    '';

  forEachGateway = f: lib.concatMapAttrs f gateways;
in
{
  options.services.openshell = {
    enable = mkEnableOption "OpenShell gateways, providers and policies";

    package = mkOption {
      type = types.package;
      default = self.packages.${system}.openshell;
      defaultText = lib.literalExpression "self.packages.\${system}.openshell";
      description = "Package providing openshell, openshell-gateway and openshell-prover.";
    };

    sharedPackage = mkOption {
      type = types.package;
      default = self.packages.${system}.openshell-shared;
      defaultText = lib.literalExpression "self.packages.\${system}.openshell-shared";
      description = "Package providing upstream share/providers and share/skills.";
    };

    gateways = mkOption {
      type = types.listOf gateway;
      default = [ { name = "openshell"; } ];
      example = lib.literalExpression ''
        [
          { name = "local"; }
          { name = "local"; settings.openshell.gateway.log_level = "debug"; }
        ]
      '';
      description = ''
        Gateways to run as user services (systemd on Linux, launchd on Darwin).

        Entries are grouped by `name` and merged with `foldl' recursiveUpdate`,
        so later entries in the list take precedence over earlier ones.

        Each gateway defaults to the docker compute driver, listens in
        plaintext on 127.0.0.1:17670 and allows unauthenticated local users.
        Gateways with distinct names must use distinct `bind_address` values.
      '';
    };

    providers = mkOption {
      type = types.listOf document;
      default = [ ];
      example = lib.literalExpression ''
        [
          "''${pkgs.openshell-shared}/share/providers/github.yaml"
          {
            id = "github";
            binaries = [
              "''${pkgs.git}/bin/git"
              "''${pkgs.gh}/bin/gh"
            ];
          }
        ]
      '';
      description = ''
        Provider profiles imported into every gateway as global profiles.

        Profiles are grouped by `id` and deep merged, so later entries in the
        list take precedence over earlier ones (lists, such as `binaries`, are
        replaced rather than appended). Global profiles not declared here are
        deleted from the gateway.
      '';
    };

    policies = mkOption {
      type = types.listOf document;
      default = [ ];
      description = ''
        Sandbox policy documents, deep merged into a single policy where later
        entries in the list take precedence over earlier ones (lists are
        replaced rather than appended). The result is exported as
        `OPENSHELL_SANDBOX_POLICY` for new sandboxes.
        See https://docs.nvidia.com/openshell/latest/how-it-works/policies/schema
      '';
    };

    globalPolicy = mkOption {
      type = types.nullOr (types.attrsOf types.anything);
      default = null;
      description = ''
        Gateway-global policy applied to every gateway. When null, any global
        policy present on the gateway is deleted.
      '';
    };

    boundaryPolicy = mkOption {
      type = types.nullOr document;
      default = null;
      description = ''
        Boundary policy. When set, the merged `policies`, `globalPolicy` and
        every sandbox `policy` are checked against it with `openshell-prover`
        at build time and the build fails if any exceeds the boundary.
      '';
    };

    opencode.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Add the upstream OpenShell skills to OpenCode when it is enabled.";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      assertions = [
        {
          assertion = isDarwin || isLinux;
          message = "services.openshell supports only Linux and Darwin.";
        }
        {
          assertion =
            let
              addresses = lib.mapAttrsToList (_: g: g.settings.openshell.gateway.bind_address) gateways;
            in
            lib.length addresses == lib.length (lib.unique addresses);
          message = "services.openshell.gateways: each gateway name needs a distinct bind_address.";
        }
        {
          assertion = lib.all (
            gatewayName:
            lib.all (
              sandboxName:
              builtins.match "[a-z0-9]([a-z0-9-]*[a-z0-9])?" sandboxName != null
              && builtins.stringLength sandboxName <= 63
            ) (lib.attrNames gateways.${gatewayName}.sandboxes)
          ) (lib.attrNames gateways);
          message = "services.openshell: every sandbox name must be a DNS-1123 label (at most 63 lowercase alphanumeric or '-' characters, beginning and ending with an alphanumeric character).";
        }
        {
          # Wrapper commands are named after their sandbox, so sandbox
          # names must be unique across all gateways.
          assertion =
            let
              names = lib.concatMap (g: lib.attrNames g.sandboxes) (lib.attrValues gateways);
            in
            lib.length names == lib.length (lib.unique names);
          message = "services.openshell: sandbox names must be unique across all gateways (each sandbox gains a generated wrapper command named after it).";
        }
      ]
      # Enforce each sandbox's own assertions; submodule assertions are
      # only checked when the parent config collects them.
      ++ lib.concatMap (g: lib.mapAttrsToList (_: s: s.assertions) g.sandboxes) (lib.attrValues gateways);

      home.packages = [ cfg.package ] ++ sandboxCommands;

      # The CLI targets the first gateway (by name) unless told otherwise.
      home.sessionVariables =
        optionalAttrs (gateways != { }) {
          OPENSHELL_GATEWAY_ENDPOINT = endpoint (lib.head (lib.attrValues gateways));
        }
        // optionalAttrs (cfg.policies != [ ]) {
          OPENSHELL_SANDBOX_POLICY = "${sandboxPolicy}";
        };

      programs.opencode.skills = mkIf (cfg.opencode.enable && config.programs.opencode.enable) (
        lib.genAttrs [
          "debug-inference"
          "debug-openshell-cluster"
          "generate-sandbox-policy"
          "openshell-cli"
        ] (skill: "${cfg.sharedPackage}/share/skills/${skill}")
      );
    }

    {
      systemd.user.services = mkIf isLinux (
        forEachGateway (
          name: gateway: {
            "openshell-gateway-${name}" = {
              Unit.Description = "OpenShell gateway ${name}";
              Service = {
                ExecStart = lib.escapeShellArgs (gatewayCommand name gateway);
                Environment = lib.mapAttrsToList (k: v: "${k}=${v}") (gatewayEnvironment name gateway);
                Restart = "on-failure";
              };
              Install.WantedBy = [ "default.target" ];
            };

            "openshell-load-${name}" = {
              Unit = {
                Description = "Load OpenShell providers and policies into gateway ${name}";
                After = [ "openshell-gateway-${name}.service" ];
                Requires = [ "openshell-gateway-${name}.service" ];
                PartOf = [ "openshell-gateway-${name}.service" ];
              };
              Service = {
                Type = "oneshot";
                ExecStart = "${loadScript name gateway}";
              };
              Install.WantedBy = [ "openshell-gateway-${name}.service" ];
            };
          }
        )
      );

      launchd.agents = mkIf isDarwin (
        forEachGateway (
          name: gateway: {
            "openshell-gateway-${name}" = {
              enable = true;
              config = {
                ProgramArguments = gatewayCommand name gateway;
                EnvironmentVariables = gatewayEnvironment name gateway;
                KeepAlive = true;
                RunAtLoad = true;
                StandardOutPath = "${config.home.homeDirectory}/Library/Logs/openshell-gateway-${name}.log";
                StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/openshell-gateway-${name}.log";
              };
            };

            # launchd has no unit ordering, the script waits for the gateway.
            "openshell-load-${name}" = {
              enable = true;
              config = {
                ProgramArguments = [ "${loadScript name gateway}" ];
                RunAtLoad = true;
                StandardOutPath = "${config.home.homeDirectory}/Library/Logs/openshell-load-${name}.log";
                StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/openshell-load-${name}.log";
              };
            };
          }
        )
      );
    }
  ]);
}
