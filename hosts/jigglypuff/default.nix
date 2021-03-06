{ config, pkgs, lib, flake, ... }:
let
  userConfigs = import ./users.nix { inherit config pkgs flake; };
  users = import ../../functions/map-reduce-users.nix {
    inherit config pkgs lib userConfigs;
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

  # Remote deploy requires passwordless root access. We can do this via --use-remote-sudo
  security.sudo.wheelNeedsPassword = false;

  virtualisation.oci-containers.backend = "docker";

  networking.hostName = "jigglypuff";
  networking.hostId = "d2a7f613";
  system.stateVersion = "22.05";
}
