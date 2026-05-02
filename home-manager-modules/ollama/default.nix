{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../../options/home-manager-modules/ollama
  ];

  programs.opencode.settings.provider = lib.mkIf config.programs.opencode.enable {
    ollama = {
      npm = "@ai-sdk/openai-compatible";
      name = "Ollama";
      options = {
        baseURL = "http://127.0.0.1:11434/v1";
      };
      models = builtins.foldl' (
        acc: model:
        acc
        // {
          "${model.model}" = {
            attachment = true;
            inherit (model) name;
            reasoning = true;
            temperature = true;
            tool_call = true;
          };
        }
      ) { } config.services.ollama.models;
    };
  };

  services.ollama = {
    enable = true;

    environmentVariables = {
      OLLAMA_CONTEXT_LENGTH = "65536";
      OLLAMA_NO_CLOUD = "1";
    };

    package = pkgs.ollama.overrideAttrs (_: {
      version = "0.20.2";
      src = pkgs.fetchFromGitHub {
        owner = "ollama";
        repo = "ollama";
        tag = "v0.20.2";
        hash = "sha256-Ic3eLOohLR7MQGkLvDJBNOCiBBKxh6l8X9MgK0b4w+Y=";
      };
    });

    models = [
      {
        name = "gemma4";
        model = "gemma4:e2b";
        roles = [
          "autocomplete"
          "chat"
          "edit"
          "rerank"
        ];
      }
    ];
  };
}
