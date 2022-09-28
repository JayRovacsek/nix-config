{ config, pkgs, lib, flake, ... }:
let
  userConfigs = import ./users.nix { inherit config pkgs; };
  users = import ../../functions/map-reduce-users.nix {
    inherit config pkgs lib userConfigs;
  };
in {
  inherit users flake;

  imports = [
    ./hardware-configuration.nix
    ./modules.nix
    ./options.nix
    ./system-packages.nix
    ./wireless.nix
  ];

  # Add wireless key to identity path
  age.identityPaths = [
    "/agenix/id-ed25519-wireless-primary"
    # "/agenix/id-ed25519-wireless-secondary"
  ];

  networking.hostName = "wigglytuff";
  networking.hostId = "d2a7b80b";
  system.stateVersion = "22.05";
}
