{ config, pkgs, lib, flake, ... }:

let
  inherit (flake) common;
  inherit (flake.lib) merge;
  inherit (flake.common.home-manager-module-sets) hyprland-desktop;

  test = common.users.test {
    inherit config pkgs;
    modules = hyprland-desktop;
  };

  merged = merge [ test ];

in {
  inherit flake;
  inherit (merged) users home-manager;

  environment.systemPackages = with pkgs; [ curl wget ];

  networking = {
    hostName = "mew";
    useDHCP = true;
  };

  system.stateVersion = "22.11";
}
