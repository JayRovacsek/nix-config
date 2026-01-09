{
  config,
  pkgs,
  lib,
  self,
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
      pop-shell
      blur-my-shell
      notification-banner-reloaded
    ]
    ++ tailscaleExtensions;
in
{
  imports = [
    self.nixosModules.gnome-minimal
    ../redshift
  ];

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
    systemPackages = with pkgs; [ gjs ] ++ gnomePackages ++ gnomeExtensions;
  };
}
