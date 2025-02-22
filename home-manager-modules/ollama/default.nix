{
  config,
  lib,
  pkgs,
  ...
}:
let
  unique-models = lib.unique config.services.ollama.models;
in
{
  imports = [
    ../../options/home-manager-modules/ollama
  ];

  home.file.".continue/config.json".text = builtins.toJSON {
    contextProviders = [
      {
        name = "code";
        params = { };
      }
      {
        name = "docs";
        params = { };
      }
      {
        name = "diff";
        params = { };
      }
      {
        name = "terminal";
        params = { };
      }
      {
        name = "problems";
        params = { };
      }
      {
        name = "folder";
        params = { };
      }
      {
        name = "codebase";
        params = { };
      }
    ];
    customCommands = [
      {
        description = "Write unit tests for highlighted code";
        name = "test";
        prompt = "{{{ input }}}\n\nWrite a comprehensive set of unit tests for the selected code. It should setup, run tests that check for correctness including important edge cases, and teardown. Ensure that the tests are complete and sophisticated. Give the tests just as chat output, don't edit any file.";
      }
    ];
    embeddingsProvider = {
      model = "nomic-embed-text";
      provider = "ollama";
    };
    models =
      (builtins.map (model: {
        inherit model;
        provider = "ollama";
        title = model;
      }) unique-models)
      ++ [
        {
          model = "AUTODETECT";
          provider = "ollama";
          title = "Ollama";
        }
      ];
    slashCommands = [
      {
        description = "Edit selected code";
        name = "edit";
      }
      {
        description = "Write comments for the selected code";
        name = "comment";
      }
      {
        description = "Export the current chat session to markdown";
        name = "share";
      }
      {
        description = "Generate a shell command";
        name = "cmd";
      }
      {
        description = "Generate a git commit message";
        name = "commit";
      }
    ];
    tabAutocompleteModel =
      let
        model = config.services.ollama.tabAutocompleteModel;
      in
      {
        inherit model;
        provider = "ollama";
        title = model;
      };
  };

  programs.vscode.extensions = lib.mkIf config.programs.vscode.enable [
    pkgs.vscode-extensions.continue.continue
  ];

  services.ollama = {
    enable = true;
    models = [
      "deepseek-r1:7b"
      "nomic-embed-text"
    ];
    tabAutocompleteModel = "deepseek-r1:7b";
  };
}
