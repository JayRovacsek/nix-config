{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.ollama;

  darwin-configuration = lib.mkIf (cfg.enable && pkgs.stdenv.isDarwin) {
    home.packages = [ cfg.package ];
    launchd.agents =
      {
        ollama-serve = {
          inherit (cfg) enable;

          config = {
            AbandonProcessGroup = true;
            ExitTimeOut = 0;
            KeepAlive = {
              Crashed = true;
              SuccessfulExit = false;
            };
            Label = "local.ollama-serve";
            ProcessType = "Background";
            ProgramArguments = [
              "${cfg.package}/bin/ollama"
              "serve"
            ];
            RunAtLoad = true;
            StandardOutPath = cfg.logFile;
            StandardErrorPath = cfg.logFile;
          };
        };
      }
      // builtins.foldl' (
        acc: model:
        (
          acc
          // {
            "ollama-run-${model}" = {
              inherit (cfg) enable;

              config = {
                AbandonProcessGroup = true;
                ExitTimeOut = 0;
                KeepAlive.OtherJobEnabled."local.ollama-serve" = true;
                Label = "ollama-run-${model}";
                ProcessType = "Background";
                ProgramArguments = [
                  "${cfg.package}/bin/ollama"
                  "run"
                  model
                ];
                RunAtLoad = true;
                StandardOutPath = cfg.logFile;
                StandardErrorPath = cfg.logFile;
              };
            };
          }
        )
      ) { } cfg.models;
  };

  linux-configuration = lib.mkIf (cfg.enable && pkgs.stdenv.isLinux) {
    home.packages = [ cfg.package ];
    systemd.user.services =
      {
        ollama-serve = {
          Install.WantedBy = [ "graphical-session.target" ];

          Service = {
            ExecStart = "${lib.getExe cfg.package} serve";
          };

          Unit = {
            After = [ "graphical-session-pre.target" ];
            Description = "Ollama Serve";
            PartOf = [ "graphical-session.target" ];
          };
        };
      }
      // builtins.foldl' (
        acc: model:
        (
          acc
          // {
            "ollama-pull-${model}" = {
              Install.WantedBy = [ "graphical-session.target" ];

              Service = {
                ExecStart = "${lib.getExe cfg.package} pull ${model}";
              };

              Unit = {
                After = [ "ollama-serve.service" ];
                Description = "Ollama Pull ${model}";
              };
            };

            "ollama-run-${model}" = {
              Install.WantedBy = [ "graphical-session.target" ];

              Service = {
                ExecStart = "${lib.getExe cfg.package} run ${model}";
              };

              Unit = {
                After = [ "ollama-pull-${model}.service" ];
                Description = "Ollama Run ${model}";
              };
            };
          }
        )
      ) { } cfg.models;
  };
in
{
  options = {
    services.ollama = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.ollama;
      };

      logFile = lib.mkOption {
        type = lib.types.str;
        default = "/tmp/ollama.log";
        example = "/var/log/ollama.log";
      };

      models = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ "nomic-embed-text" ];
        example = [
          "llama3"
          "phi3:3.8b"
        ];
      };

      tabAutocompleteModel = lib.mkOption {
        type = lib.types.str;
        default = "llama3";
        example = "phi3:3.8b";
      };
    };
  };

  config = darwin-configuration // linux-configuration;
}
