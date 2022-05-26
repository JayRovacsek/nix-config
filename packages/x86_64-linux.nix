{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    # CLI Utilities
    awscli
    exfat
    git
    htop
    jq
    killall
    lsd
    tree

    # Utils
    cifs-utils
    dnsutils
    exiftool
    hddtemp
    lm_sensors
    pciutils
    traceroute
    gparted

    # Browsers
    brave

    # Productivity
    keepassxc
    libvirt
    unzip
    gimp
    jellyfin-media-player
    inkscape

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
    polymc

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
