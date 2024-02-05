{ pkgs, lib, osConfig, ... }:
let
  inherit (lib.strings) hasInfix;

  darwin-packages = with pkgs; [
    # CLI Utilities
    git
    htop
    # This is required as the version of SSH on darwin is garbage and doesn't support
    # yubikeys properly.
    # Adding open ssh will mean it ranks higher in path leading to a suitable SSH
    # package to back both SSH and git
    openssh

    # Need to work on the below - but this _should_ be in shell.nix but vscode doesn't work this way just yet.
    nodejs
    nodePackages.typescript

    # Secrets Management
    yubikey-personalization

    ## Misc
    hunspell
    hunspellDicts.en-au
  ];

  linux-packages = with pkgs; [
    # CLI Utilities
    git
    htop
    killall

    ## Misc
    hunspell
    hunspellDicts.en-au
  ];

  # TODO: refactor this into a getAttr rather than if statement.
  cfg = if hasInfix "darwin" osConfig.nixpkgs.system then {
    home.packages = darwin-packages;
  } else {
    home.packages = linux-packages;
  };
in cfg
