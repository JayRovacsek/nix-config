{ config, pkgs, lib, flake, ... }:
let
  userConfigs = import ./users.nix { inherit config pkgs; };
  users = import ../../functions/map-reduce-users.nix {
    inherit config pkgs lib userConfigs;
  };
in {
  inherit flake users;

  imports = [ ./modules.nix ./system-packages.nix ./secrets.nix ];

  services.nix-daemon.enable = true;

  networking = {
    computerName = "cloyster";
    hostName = "cloyster";
    localHostName = "cloyster";
  };

  system.stateVersion = 4;
}
