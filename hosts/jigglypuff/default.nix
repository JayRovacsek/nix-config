{ config, pkgs, lib, ... }:
let
  userFunction = import ../../functions/map-reduce-users.nix;
  userConfigs = (import ./users.nix).users;
  users = userFunction { users = userConfigs; };
in {
  inherit users;
  imports =
    [ ./hardware-configuration.nix ./modules.nix ./system-packages.nix ];

  networking.hostName = "jigglypuff";
  networking.hostId = "d2a7f613";
}
