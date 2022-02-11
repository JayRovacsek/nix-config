{ config, pkgs, lib, ... }: {

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.displayManager.gdm = {
    enable = true;
    nvidiaWayland = false;
    wayland = false;
  };

  services.xserver.displayManager.autoLogin = {
    enable = true;
    user = "jay";
  };

  # If using gnome desktop manager, exclude these from installation
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
