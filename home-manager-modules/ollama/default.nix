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

  nixpkgs.overlays = [
    (_: prev: {
      ollama-git = prev.ollama.overrideAttrs (_: {
        version = "0.20.8-rc0";
        src = prev.fetchFromGitHub {
          owner = "ollama";
          repo = "ollama";
          tag = "v0.20.8-rc0";
          hash = "sha256-J/VLij0MVuJ64m0NiT9n1vwAg8MxJpPHbhoeVZTnZAE=";
        };
      });
    })
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

  programs.vscode.profiles.default = {
    userSettings."yaml.schemas"."file://${config.home.homeDirectory}/.vscode-oss/extensions/Continue.continue/config-yaml-schema.json" =
      [
        ".continue/**/*.yaml"
      ];
  };

  services.ollama = {
    enable = true;

    environmentVariables = {
      OLLAMA_CONTEXT_LENGTH = "131072";
      OLLAMA_NO_CLOUD = "1";
    };

    package = pkgs.ollama-git;

    models = [
      {
        name = "gemma4";
        model = "gemma4:latest";
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
