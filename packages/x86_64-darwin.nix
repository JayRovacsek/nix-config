{ config, pkgs, ... }: {

  home.packages = with pkgs; [
    # CLI Utilities
    aws
    git
    htop
    jq

    # Secrets Management
    yubikey-personalization

    ## Misc
    hunspell
    hunspellDicts.en-au
    pkg-config
  ];
}
