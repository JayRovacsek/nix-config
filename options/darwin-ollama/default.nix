{ config, pkgs, lib, ... }:
let cfg = config.services.ollama;
in {
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
        default = [ "llama3" ];
        example = [ "llama3" "starcoder2:3b" ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
    launchd.agents = {
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
          ProgramArguments = [ "${cfg.package}/bin/ollama" "serve" ];
          RunAtLoad = true;
          StandardOutPath = cfg.logFile;
          StandardErrorPath = cfg.logFile;
        };
      };
    } // builtins.foldl' (acc: model:
      (acc // {
        "ollama-run-${model}" = {
          inherit (cfg) enable;

          config = {
            AbandonProcessGroup = true;
            ExitTimeOut = 0;
            KeepAlive.OtherJobEnabled."local.ollama-serve" = true;
            Label = "ollama-run-${model}";
            ProcessType = "Background";
            ProgramArguments = [ "${cfg.package}/bin/ollama" "run" model ];
            RunAtLoad = true;
            StandardOutPath = cfg.logFile;
            StandardErrorPath = cfg.logFile;
          };
        };
      })) { } cfg.models;
  };
}
