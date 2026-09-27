{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  cfg = config.services.laya;

  hf = pkgs.python3Packages.huggingface-hub;

  instanceModule = {
    options = {
      model = lib.mkOption {
        type = lib.types.submodule {
          options = {
            repo = lib.mkOption {
              type = lib.types.str;
              description = "Hugging Face repository hosting the model.";
              example = "mys/laya-GGUF";
            };

            file = lib.mkOption {
              type = lib.types.str;
              description = "Model file within the repository.";
              example = "laya_english_ud_q4_k_m.gguf";
            };
          };
        };
        description = ''
          Model this instance serves. It is pulled into the standard Hugging
          Face cache directory (services.laya.hfHome) and read from there on
          subsequent starts.
        '';
        example = lib.literalExpression ''
          {
            repo = "mys/laya-GGUF";
            file = "laya_english_ud_q4_k_m.gguf";
          }
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8080;
        description = "Port this instance listens on.";
      };

      extraArgs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = ''
          Additional arguments inserted before the model path in the
          `laya serve` command.
        '';
        example = [
          "--cuda-graph"
        ];
      };

      device = lib.mkOption {
        type = lib.types.enum [
          "auto"
          "cpu"
          "cuda"
          "metal"
          "vulkan"
        ];
        default = "auto";
        description = "Backend used for inference.";
      };

      threads = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = "Number of CPU threads to use; null leaves the laya default.";
      };

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          File of environment variables for the service, for example to set
          `LAYA_API_KEY` when exposing the TypeSafe API.
        '';
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to open this instance's port in the firewall. The laya server
          always binds all interfaces, so this is the only exposure control;
          leave it disabled for local-only access.
        '';
      };
    };
  };
in
{
  options.services.laya = {
    enable = lib.mkEnableOption "the laya System-1 decision server";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage (self.outPath + "/packages/python/ggmlc") {
        inherit self pkgs;
      };
      defaultText = lib.literalExpression ''
        pkgs.callPackage <flake>/packages/python/ggmlc { inherit self pkgs; }
      '';
      description = ''
        Package providing the `laya` binary. It is built from this flake
        against the system's `pkgs`, so it follows `config.cudaSupport`: a
        CUDA-capable system gets a CUDA build, otherwise a CPU build. Override
        to pin a specific build.
      '';
    };

    hfHome = lib.mkOption {
      type = lib.types.path;
      default = "${cfg.dataDir}/.cache/huggingface";
      description = ''
        Hugging Face home directory (`HF_HOME`) used to cache downloaded
        models, in the standard `hub/` layout.
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/laya";
      description = "Working directory and home directory for the service.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "laya";
      description = "User the instances run as.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = cfg.user;
      description = "Group the instances run as.";
    };

    instances = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule instanceModule);
      default = { };
      description = "Laya server instances, keyed by name.";
      example = lib.literalExpression ''
        {
          email = {
            model = {
              repo = "mys/laya-GGUF";
              file = "laya_english_ud_q4_k_m.gguf";
            };
            port = 8080;
            openFirewall = true;
          };
          triage = {
            model = {
              repo = "mys/laya-GGUF";
              file = "laya_english_q8_0.gguf";
            };
            port = 8081;
          };
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion =
          let
            ports = lib.mapAttrsToList (_: instance: instance.port) cfg.instances;
          in
          lib.length ports == lib.length (lib.unique ports);
        message = "services.laya.instances must not share a port";
      }
    ];

    networking.firewall.allowedTCPPorts = lib.concatLists (
      lib.mapAttrsToList (_: instance: lib.optional instance.openFirewall instance.port) cfg.instances
    );

    systemd.services = lib.mapAttrs' (
      name: instance:
      let
        serve = pkgs.writeShellApplication {
          name = "laya-serve-${name}";
          text = ''
            model=$(${lib.getExe' hf "hf"} download ${lib.escapeShellArg instance.model.repo} ${lib.escapeShellArg instance.model.file} --quiet 2>/dev/null)
            exec ${lib.getExe' cfg.package "laya"} serve "$@" "$model"
          '';
        };
      in
      lib.nameValuePair "laya-${name}" {
        description = "laya System-1 decision server (${name})";
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];

        serviceConfig = {
          Type = "simple";
          Environment = [ "HF_HOME=${toString cfg.hfHome}" ];
          environmentFile = lib.optional (instance.environmentFile != null) instance.environmentFile;
          User = cfg.user;
          Group = cfg.group;
          WorkingDirectory = cfg.dataDir;
          Restart = "on-failure";
          RestartSec = 5;
          ExecStart = [
            (lib.getExe serve)
          ]
          ++ instance.extraArgs
          ++ [
            "--port"
            (toString instance.port)
            "--device"
            instance.device
          ]
          ++ lib.optionals (instance.threads != null) [
            "--threads"
            (toString instance.threads)
          ];
        };
      }
    ) cfg.instances;

    users = {
      groups.${cfg.group} = { };
      users.${cfg.user} = {
        inherit (cfg) group;
        description = "laya service user";
        isSystemUser = true;
        home = cfg.dataDir;
        createHome = true;
      };
    };
  };
}
