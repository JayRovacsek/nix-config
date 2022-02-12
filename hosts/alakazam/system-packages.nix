{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # CLI
    curl
    vim
    wget

    # Yubikey
    libfido2

    # Nvidia
    linuxPackages.nvidia_x11

    # System Notifications
    libnotify
  ];

  environment.gnome.excludePackages = with pkgs; [
    gnome.cheese
    gnome-photos
    gnome.gnome-music
    gnome.gedit
    epiphany
    evince
    gnome.gnome-characters
    gnome.totem
    gnome.tali
    gnome.iagno
    gnome.hitori
    gnome.atomix
    gnome.gnome-weather
    gnome.gnome-screenshot
    gnome.gnome-contacts
    gnome.gnome-maps
    gnome.geary
    gnome-tour
    gnome-connections
  ];
}
