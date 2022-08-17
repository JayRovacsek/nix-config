{ config, pkgs, ... }: {

  home.packages = with pkgs; [
    # CLI Utilities
    awscli
    git
    htop
    jq
    # This is required as the version of SSH on darwin is garbage and doesn't support
    # yubikeys properly.
    # Adding open ssh will mean it ranks higher in path leading to a suitable SSH
    # package to back both SSH and git
    openssh

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
