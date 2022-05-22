{ config, pkgs, lib, ... }:
let
  userFunction = import ../../functions/map-reduce-users.nix;
  userConfigs = import ./users.nix;
  users = userFunction { inherit pkgs userConfigs; };
in {
  inherit users;
  imports = [
    ./hardware-configuration.nix
    ./modules.nix
    ./system-packages.nix
    ./wireless.nix
  ];

  networking.hostName = "jigglypuff";
  networking.hostId = "d2a7f613";
}
