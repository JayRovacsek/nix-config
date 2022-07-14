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
    ./vlans.nix
  ];

  virtualisation.oci-containers.backend = "docker";

  networking.hostName = "jigglypuff";
  networking.hostId = "d2a7f613";
  system.stateVersion = "22.11";
}
