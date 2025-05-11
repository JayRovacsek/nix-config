{ lib, pkgs, ... }:
let
  nix-options = pkgs.fetchFromGitHub {
    owner = "JayRovacsek";
    repo = "nix-options";
    rev = "main";
    hash = "sha256-WJXBKCYJkD7B6wwUY+CHriexVX/+Bsw5AHg83QVBQLY=";
  };
in
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    package = pkgs.vscodium;

    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;

      extensions =
        with pkgs.vscode-extensions;
        [
          # Nix
          jnoortheen.nix-ide
          mkhl.direnv

          # JS/TS
          dbaeumer.vscode-eslint

          # XML
          redhat.vscode-xml

          # YAML
          redhat.vscode-yaml

          # TOML
          tamasfe.even-better-toml

          # Terraform
          hashicorp.terraform

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
          bierner.markdown-mermaid
          bierner.markdown-preview-github-styles
        ]
        ++ lib.optionals (!(pkgs.stdenv.isLinux && pkgs.stdenv.isAarch64)) [
          # Python
          # Turns out that the below are not supported on aarch64 linux
          ms-python.python
          ms-python.debugpy
        ];

      keybindings = [
        {
          key = "cmd+`";
          command = "workbench.action.terminal.toggleTerminal";
          when = "terminal.active";
        }
      ];
      userSettings = {
        "[dockercompose]" = {
          "editor.defaultFormatter" = "ms-azuretools.vscode-docker";
        };
        "[go]" = {
          "editor.defaultFormatter" = "golang.go";
        };
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
        "[latex]" = {
          "editor.defaultFormatter" = "James-Yu.latex-workshop";
        };
        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
        };
        "[typescript]" = {
          "editor.defaultFormatter" = "dbaeumer.vscode-eslint";
        };
        "[typescriptreact]" = {
          "editor.defaultFormatter" = "dbaeumer.vscode-eslint";
        };
        "[xml]" = {
          "editor.defaultFormatter" = "redhat.vscode-xml";
        };
        "[yaml]" = {
          "editor.formatOnSave" = true;
        };

        "chat.commandCenter.enabled" = false;

        "debug.javascript.autoAttachFilter" = "smart";
        "diffEditor.maxComputationTime" = 0;
        "diffEditor.wordWrap" = "off";
        "direnv.path.executable" = "${pkgs.direnv}/bin/direnv";
        "direnv.restart.automatic" = true;
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
        "javascript.updateImportsOnFileMove.enabled" = "always";
        "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
        "nix.enableLanguageServer" = true;
        "nix.formatterPath" = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
        "nix.serverSettings" = {
          nixd = {
            formatting.command = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];
            "options" = {
              darwin.expr = ''(builtins.getFlake "${nix-options}").options.darwin'';
              home-manager.expr = ''(builtins.getFlake "${nix-options}").options.home-manager'';
              nixos.expr = ''(builtins.getFlake "${nix-options}").options.nixos'';
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
    };
  };
}
