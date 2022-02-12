{ config, lib, pkgs, ... }: {

  programs.home-manager.enable = true;
  home.username = "jay";
  home.homeDirectory = "/home/jay";
  home.stateVersion = "22.05";
  home.packages = with pkgs; [
    # CLI Utilities
    aws
    exfat
    git
    htop
    jq
    killall
    lsd
    nmap
    starship
    tree

    # Terminal
    alacritty

    # Utils
    # bintools
    cifs-utils
    dnsutils
    exiftool
    hddtemp
    lm_sensors
    pciutils
    traceroute

    # Browsers
    firefox
    ungoogled-chromium

    # Fonts
    nerdfonts

    # Productivity
    keepassxc
    libvirt
    pigz
    wireshark
    unzip
    nextcloud-client
    gimp
    libreoffice-fresh
    yubikey-manager-qt
    smartmontools
    gnomeExtensions.sensory-perception
    gnomeExtensions.caffeine
    gnomeExtensions.screenshot-tool
    gnomeExtensions.dash-to-panel
    yubikey-personalization

    # Development
    vscode

    ## Nix
    nixfmt

    ## Virtualisation
    docker-compose
    wine

    ## Tex
    texlive.combined.scheme-full

    ## X Utils
    libpng
    libxkbcommon
    xorg.libX11.dev
    xorg.libXtst
    xorg.xcbutil
    xorg.xcbutilkeysyms

    ## OpenGL
    glfw

    # Games
    runelite

    # Communication
    discord
    signal-desktop
    thunderbird
    slack

    ## Misc
    hunspell
    hunspellDicts.en-au
    pkg-config
  ];
}
