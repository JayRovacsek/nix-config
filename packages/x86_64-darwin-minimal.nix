{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    # CLI Utilities
    git
    htop
    jq
    unzip
    direnv

    # Terminal
    alacritty

    # Network Tools
    nmap

    # Secrets Management
    keepassxc

    ## Misc
    hunspell
    hunspellDicts.en-au
  ];
}
