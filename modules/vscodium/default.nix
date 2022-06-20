{ config, pkgs, lib, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  package = if isDarwin then { } else { package = pkgs.vscodium; };
in {
  programs.vscode = {
    enable = true;

    mutableExtensionsDir = false;

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
      "[nix]" = { "editor.defaultFormatter" = "brettm12345.nixfmt-vscode"; };
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
      "editor.fontFamily" = "Hack Nerd Font";
      "editor.fontLigatures" = true;
      "editor.fontSize" = 14;
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
      "redhat.telemetry.enabled" = false;
      "security.workspace.trust.untrustedFiles" = "open";
      "terminal.explorerKind" = "external";
      "terminal.external.linuxExec" = "alacritty";
      "terminal.external.osxExec" =
        "/Users/jrovacsek/Applications/Home Manager Apps/Alacritty.app";
      "terminal.integrated.defaultProfile.linux" = "zsh";
      "terminal.integrated.fontFamily" = "Hack Nerd Font";
      "terminal.integrated.fontSize" = 12;
      "typescript.updateImportsOnFileMove.enabled" = "always";
      "window.menuBarVisibility" = "toggle";
      "window.titleBarStyle" = "custom";
      "oneDarkPro.editorTheme" = "Retro";
      "workbench.colorTheme" = "Tomorrow Night Blue";
      "workbench.iconTheme" = "material-icon-theme";
    };

    extensions = with pkgs.vscode-extensions; [

      # Nix
      bbenoist.nix
      jnoortheen.nix-ide
      brettm12345.nixfmt-vscode
      arrterian.nix-env-selector

      # JS/TS
      dbaeumer.vscode-eslint

      # XML
      dotjoshjohnson.xml

      # YAML
      redhat.vscode-yaml

      # Go
      golang.go

      # Terraform
      hashicorp.terraform

      # Latex
      james-yu.latex-workshop

      # Rust
      matklad.rust-analyzer
      vadimcn.vscode-lldb

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
  } // package;
}

