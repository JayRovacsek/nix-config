{ config, pkgs, lib, flake, ... }:
let
  userConfigs = import ./users.nix { inherit config pkgs; };
  users = import ../../functions/map-reduce-users.nix {
    inherit config pkgs lib userConfigs;
  };
in {
  inherit users;

  recursive = { inherit flake; };

  imports = [ ./modules.nix ./options.nix ./system-packages.nix ./secrets.nix ];

  services.nix-daemon.enable = true;

  networking = {
    # RIP, need to use the below values.
    computerName = "victreebel";
    hostName = "victreebel";
    localHostName = "victreebel";
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = 4;
}
