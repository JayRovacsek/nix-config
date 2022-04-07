{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    # CLI Utilities
    aws
    git
    htop
    jq
    lsd

    # Terminal
    alacritty

    # Secrets Management
    yubikey-personalization

    ## Misc
    hunspell
    hunspellDicts.en-au
    pkg-config
  ];
}
