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
    ./vlans.nix
    ./wireless.nix
  ];

  networking.hostName = "wigglytuff";
  networking.hostId = "d2a7b80b";
  system.stateVersion = "22.05";
}
