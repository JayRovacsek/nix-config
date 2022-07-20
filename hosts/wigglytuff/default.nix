{ config, pkgs, lib, flake, ... }:
let
  userConfigs = import ./users.nix { inherit config pkgs; };
  users = import ../../functions/map-reduce-users.nix {
    inherit config pkgs userConfigs;
  };
in {
  inherit users;
  imports = [
    ./hardware-configuration.nix
    ./modules.nix
    ./options.nix
    ./system-packages.nix
    ./wireless.nix
  ];

  networking.hostName = "wigglytuff";
  networking.hostId = "d2a7b80b";
  system.stateVersion = "22.05";
}
