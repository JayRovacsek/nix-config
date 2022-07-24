{ config, pkgs, lib, flake, ... }:
let
  userConfigs = import ./users.nix { inherit config pkgs flake; };
  users = import ../../functions/map-reduce-users.nix {
    inherit config pkgs lib userConfigs;
  };
in {
  inherit users;

  imports = [ ./modules.nix ./system-packages.nix ./secrets.nix ];

  services.nix-daemon.enable = true;

  networking = {
    computerName = "ninetales";
    hostName = "ninetales";
    localHostName = "ninetales";
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = 4;
}
