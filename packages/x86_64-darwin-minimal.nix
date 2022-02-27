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
    starship

    # Network Tools
    nmap

    # Secrets Management
    keepassxc

    # Development
    vscode

    ## Misc
    hunspell
    hunspellDicts.en-au
  ];
}
