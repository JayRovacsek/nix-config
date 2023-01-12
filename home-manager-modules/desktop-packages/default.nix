{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    # CLI Utilities
    git
    htop
    killall

    # Browsers
    brave

    # Productivity
    keepassxc
    libvirt
    gimp
    jellyfin-media-player
    nextcloud-client

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
