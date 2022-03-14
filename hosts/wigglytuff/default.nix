{ config, pkgs, lib, ... }:
let
  userFunction = import ../../functions/map-reduce-users.nix;
  userConfigs = (import ./users.nix).users;
  users = userFunction { inherit pkgs userConfigs; };
in {
  inherit users;
  imports = [
    ./hardware-configuration.nix
    ./modules.nix
    ./system-packages.nix
    ./wireless.nix
  ];

  networking.hostName = "wigglytuff";
  networking.hostId = "d2a7b80b";
}
