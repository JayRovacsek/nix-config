{
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

    ## C
    gcc
    gnumake

    ## Python
    python311

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

    ## Virtualisation
    docker
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
    lutris
    runelite
    minecraft

    # Game Requirements
    ## Origin: https://github.com/lutris/docs/blob/master/Origin.md
    alsaPlugins
    dbus
    gnutls
    libgcrypt
    libgpgerror
    libxml2
    mono
    protontricks
    SDL2
    wine
    winetricks

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
