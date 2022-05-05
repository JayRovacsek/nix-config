{ config, pkgs, ... }: {

  home.packages = with pkgs; [
    # CLI Utilities
    awscli
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
