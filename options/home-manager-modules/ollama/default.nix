{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.ollama;

  model = with lib; {
    options = with types; {
      name = lib.mkOption {
        type = str;
      };

      provider = lib.mkOption {
        type = str;
        default = "ollama";
      };

      model = lib.mkOption {
        type = str;
      };

      roles = lib.mkOption {
        type = listOf (
          lib.types.enum [
            "autocomplete"
            "chat"
            "edit"
            "embed"
            "rerank"
          ]
        );
        default = [ ];
      };
    };
  };

  EnvironmentVariables = {
    OLLAMA_CONTEXT_LENGTH = "65536";
    OLLAMA_NO_CLOUD = "1";
  };

  darwin-configuration = lib.mkIf (cfg.enable && pkgs.stdenv.isDarwin) {
    home.packages = [ cfg.package ];
    launchd.agents = {
      ollama-serve = {
        inherit (cfg) enable;

        config = {
          inherit EnvironmentVariables;

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
          "ollama-run-${model.name}" = {
            inherit (cfg) enable;

            config = {
              inherit EnvironmentVariables;

              AbandonProcessGroup = true;
              ExitTimeOut = 0;
              KeepAlive.OtherJobEnabled."local.ollama-serve" = true;
              Label = "ollama-run-${model.name}";
              ProcessType = "Background";
              ProgramArguments = [
                "${cfg.package}/bin/ollama"
                "run"
                model.model
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
    systemd.user.services = {
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
          "ollama-pull-${model.name}" = {
            Install.WantedBy = [ "graphical-session.target" ];

            Service = {
              ExecStart = "${lib.getExe cfg.package} pull ${model.name}";
            };

            Unit = {
              After = [ "ollama-serve.service" ];
              Description = "Ollama Pull ${model.name}";
            };
          };

          "ollama-run-${model.name}" = {
            Install.WantedBy = [ "graphical-session.target" ];

            Service = {
              ExecStart = "${lib.getExe cfg.package} run ${model.name}";
            };

            Unit = {
              After = [ "ollama-pull-${model.name}.service" ];
              Description = "Ollama Run ${model.name}";
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
      logFile = lib.mkOption {
        type = lib.types.str;
        default = "/tmp/ollama.log";
        example = "/var/log/ollama.log";
      };

      models = lib.mkOption {
        type = with lib.types; listOf (submodule model);
        default = [
          {
            name = "nomic-embed-text";
            model = "nomic-embed-text";
            roles = [ "embed" ];
          }
        ];
        example = [
          {
            name = "nomic-embed-text";
            model = "nomic-embed-text";
            roles = [ "embed" ];
          }
          {
            name = "devstral-small-2";
            model = "devstral-small-2";
            roles = [
              "autocomplete"
              "chat"
              "edit"
              "rerank"
            ];
          }
        ];
      };
    };
  };

  # TODO: investigate if this needs to be split across OSes, or if we can better handle both at once.
  # This currently fails on darwin as it seems to be clobbered by linux options
  config = lib.mkMerge [
    darwin-configuration
    linux-configuration
  ];
}
