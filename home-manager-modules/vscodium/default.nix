{ pkgs, ... }:
let
  # This is done to avoid circular dependencies within the flake lockfile.
  # There is very little point downloading two copies of all inputs of this 
  # flake. As you cannot supply the flake itself as a followable input
  # to other inputs.
  # In reality, the source likely will match if you ensure update cycles,
  # however this is kinda gross still as the lockfile is littered with
  # references to X_2 for all inputs.
  nix-options = pkgs.fetchFromGitHub {
    owner = "JayRovacsek";
    repo = "nix-options";
    rev = "4142d6dd0a1bd97ede240e84bf87c8f65a0ccbfd";
    hash = "sha256-jxNmMjtan/TUnzo5ZTw7uWhsgzHTlmvOIXNgNn9Z46o=";
  };
in {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = false;

    keybindings = [{
      key = "cmd+`";
      command = "workbench.action.terminal.toggleTerminal";
      when = "terminal.active";
    }];

    userSettings = {
      "[dockercompose]" = {
        "editor.defaultFormatter" = "ms-azuretools.vscode-docker";
      };
      "[go]" = { "editor.defaultFormatter" = "golang.go"; };
      "[javascript]" = {
        "editor.defaultFormatter" = "dbaeumer.vscode-eslint";
      };
      "[javascriptreact]" = {
        "editor.defaultFormatter" = "dbaeumer.vscode-eslint";
      };
      "[json]" = {
        "editor.defaultFormatter" = "vscode.json-language-features";
      };
      "[jsonc]" = {
        "editor.defaultFormatter" = "vscode.json-language-features";
      };
      "[latex]" = { "editor.defaultFormatter" = "James-Yu.latex-workshop"; };
      "[nix]" = { "editor.defaultFormatter" = "jnoortheen.nix-ide"; };
      "[typescript]" = {
        "editor.defaultFormatter" = "dbaeumer.vscode-eslint";
      };
      "[typescriptreact]" = {
        "editor.defaultFormatter" = "dbaeumer.vscode-eslint";
      };
      "[xml]" = { "editor.defaultFormatter" = "redhat.vscode-xml"; };
      "[yaml]" = { "editor.formatOnSave" = false; };
      "debug.javascript.autoAttachFilter" = "smart";
      "diffEditor.maxComputationTime" = 0;
      "diffEditor.wordWrap" = "off";
      "editor.bracketPairColorization.enabled" = true;
      "editor.fontFamily" = "Hack Nerd Font Mono";
      "editor.fontLigatures" = false;
      "editor.formatOnSave" = true;
      "editor.guides.bracketPairs" = "active";
      "editor.maxTokenizationLineLength" = 10000;
      "editor.minimap.enabled" = false;
      "editor.unicodeHighlight.ambiguousCharacters" = false;
      "editor.wordWrap" = "on";
      "eslint.format.enable" = true;
      "eslint.lintTask.enable" = true;
      "explorer.confirmDelete" = false;
      "explorer.confirmDragAndDrop" = false;
      "git.autofetch" = false;
      "git.confirmSync" = false;
      "git.enableSmartCommit" = true;
      "go.toolsManagement.autoUpdate" = true;
      "javascript.updateImportsOnFileMove.enabled" = "always";
      "latex-workshop.view.pdf.viewer" = "tab";

      "nixEnvSelector.nixFile" = "\${workspaceRoot}/shell.nix";
      "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
      "nix.formatterPath" = "${pkgs.nixfmt}/bin/nixfmt";
      "nix.enableLanguageServer" = true;
      "nix.serverSettings" = {
        nixd = {
          formatting.command = "${pkgs.nixfmt}/bin/nixfmt";
          options = {
            enable = true;
            target = {
              args = [ ];
              installable = "${nix-options}#options";
            };
          };
        };
      };

      "redhat.telemetry.enabled" = false;
      "security.workspace.trust.untrustedFiles" = "open";
      "terminal.integrated.defaultProfile.linux" = "zsh";
      "terminal.integrated.fontFamily" = "Hack Nerd Font Mono";
      "terminal.integrated.defaultProfile.osx" = "zsh";
      "terminal.integrated.shellIntegration.enabled" = false;
      "typescript.updateImportsOnFileMove.enabled" = "always";
      "window.titleBarStyle" = "custom";
      "workbench.colorTheme" = "Tomorrow Night Blue";
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.settings.editor" = "json";
    };

    extensions = with pkgs.vscode-extensions; [

      # Nix
      jnoortheen.nix-ide
      arrterian.nix-env-selector

      # JS/TS
      dbaeumer.vscode-eslint

      # XML
      redhat.vscode-xml

      # YAML
      redhat.vscode-yaml

      # TOML
      tamasfe.even-better-toml

      # Go
      golang.go

      # Terraform
      hashicorp.terraform

      # Latex
      james-yu.latex-workshop

      # Rust
      matklad.rust-analyzer

      # Spellcheck
      streetsidesoftware.code-spell-checker

      # Shell
      timonwong.shellcheck

      # Docker
      ms-azuretools.vscode-docker

      # Theme
      zhuangtongfa.material-theme

      # Icons
      pkief.material-icon-theme

      # Markdown
      yzhang.markdown-all-in-one
    ];
  };
}

