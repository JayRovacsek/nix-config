{ config, pkgs, ... }:
let
  userFunction = import ../../functions/map-reduce-users.nix;
  userConfigs = import ./users.nix { inherit config pkgs; };
  users = userFunction { inherit userConfigs; };
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
