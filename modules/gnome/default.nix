{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib.lists) optionals;

  tailscaleExtensions = optionals config.services.tailscale.enable (
    with pkgs.gnomeExtensions; [ tailscale-status ]
  );

  gnomePackages = with pkgs.gnome; [
    gnome-tweaks
    nautilus
    dconf-editor
    gnome-screenshot
  ];
  gnomeExtensions =
    with pkgs.gnomeExtensions;
    [
      caffeine
      screenshot-tool
      sensory-perception
      pop-shell
      blur-my-shell
      notification-banner-reloaded
    ]
    ++ tailscaleExtensions;
in
{
  imports = [ ../redshift ];

  services = {
    # Gnome wants this by default, I really don't need it.
    # https://github.com/NixOS/nixpkgs/blob/9a12573d6fde9d5aabbf242da144804454c5080c/nixos/modules/services/x11/desktop-managers/gnome.nix#L413
    # It can rack off.
    avahi.enable = false;

    gvfs.enable = true;

    xserver = {
      enable = true;
      desktopManager.gnome.enable = true;
    };
  };

  environment = {
    # If using gnome desktop manager, exclude these from installation
    gnome.excludePackages = with pkgs; [
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

    systemPackages = with pkgs; [ gjs ] ++ gnomePackages ++ gnomeExtensions;
  };
}
