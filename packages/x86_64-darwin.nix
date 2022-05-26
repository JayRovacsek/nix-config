{ config, pkgs, ... }: {

  home.packages = with pkgs; [
    # CLI Utilities
    awscli
    git
    htop
    jq

    # Need to work on the below - but this _should_ be in shell.nix but vscode doesn't work this way just yet.
    nodejs
    nodePackages.typescript
    nodePackages.npm

    # Secrets Management
    yubikey-personalization

    ## Misc
    hunspell
    hunspellDicts.en-au
    pkg-config
  ];
}
