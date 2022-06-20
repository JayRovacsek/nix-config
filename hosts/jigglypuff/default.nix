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
  ];

  virtualisation.oci-containers.backend = "docker";

  networking.hostName = "jigglypuff";
  networking.hostId = "d2a7f613";
  system.stateVersion = "22.11";
}
