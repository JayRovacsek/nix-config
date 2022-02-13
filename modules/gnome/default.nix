{ config, pkgs, lib, ... }: {

  imports = [ ../redshift ];

  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.enable = true;

  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = false;
  };

  services.xserver.displayManager.autoLogin = {
    enable = true;
    user = "jay";
  };

  services.gvfs.enable = true;

  environment.systemPackages = with pkgs; [
    gjs
    gnome.gnome-tweaks
    gnome.nautilus
    gnome.dconf-editor
    gnomeExtensions.caffeine
    gnomeExtensions.screenshot-tool
    gnomeExtensions.dash-to-panel
    gnomeExtensions.sensory-perception
    gnomeExtensions.custom-hot-corners-extended
    gnomeExtensions.pop-shell
    gnomeExtensions.improved-workspace-indicator
    gnomeExtensions.blur-my-shell
    gnomeExtensions.notification-banner-reloaded
  ];

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
    gnome.gnome-contacts
    gnome.gnome-maps
    gnome.geary
    gnome-tour
    gnome-connections
  ];
}
