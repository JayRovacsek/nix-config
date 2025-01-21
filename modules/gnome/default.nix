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

  gnomePackages = with pkgs; [
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
      cheese
      gnome-photos
      gnome-music
      gedit
      epiphany
      evince
      gnome-characters
      totem
      tali
      iagno
      hitori
      atomix
      gnome-weather
      gnome-contacts
      gnome-maps
      geary
      gnome-tour
      gnome-connections
    ];

    systemPackages = with pkgs; [ gjs ] ++ gnomePackages ++ gnomeExtensions;
  };
}
