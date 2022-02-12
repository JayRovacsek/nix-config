{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    # CLI Utilities
    exfat
    git
    htop
    jq
    killall
    lsd
    tree
    unzip

    # Password Management
    keepassxc

    ## Misc
    hunspell
    hunspellDicts.en-au
  ];
}
