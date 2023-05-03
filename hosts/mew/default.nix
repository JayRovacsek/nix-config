{ config, pkgs, lib, flake, ... }:

let
  inherit (flake) common;
  inherit (flake.lib) merge;
  inherit (flake.common.home-manager-module-sets) hyprland-desktop;

  test = common.users.test {
    inherit config pkgs;
    modules = hyprland-desktop;
  };

  merged = merge { users = [ test ]; };

in {
  inherit flake;
  inherit (merged) users home-manager;

  imports = [ ./modules.nix ./system-packages.nix ];

  networking = {
    hostName = "mew";
    useDHCP = true;
  };

  system.stateVersion = "22.11";
}
