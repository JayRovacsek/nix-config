{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    # CLI Utilities
    aws
    git
    htop
    jq
    lsd
    pciutils
    tree
    pigz
    unzip

    # Terminal
    alacritty

    # Network Tools
    nmap
    wireshark

    # Fonts
    nerdfonts

    # Secrets Management
    keepassxc
    yubikey-personalization

    ## C
    gcc
    gnumake

    ## Python
    python3Full

    ## Rust
    cargo
    clippy
    rust-analyzer
    rustc
    rustfmt

    ## NodeJS
    nodejs
    nodePackages.npm
    nodePackages.typescript

    ## Nix
    nixfmt

    ## Golang
    delve
    go
    go-outline
    go-tools
    gopls

    ## Tex
    texlive.combined.scheme-full

    ## Misc
    hunspell
    hunspellDicts.en-au
    pkg-config
  ];
}
