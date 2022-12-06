{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    # CLI Utilities
    exfat
    git
    htop
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
