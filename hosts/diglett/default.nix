{ config, pkgs, flake, provider, ... }:

let
  inherit (flake) common;
  inherit (flake.common.home-manager-module-sets) minimal-cli;
  inherit (flake.lib) merge-user-config;

  jay = common.users.jay {
    inherit config pkgs;
    modules = minimal-cli;
  };

  merged = merge-user-config { users = [ jay ]; };
in {
  inherit flake;
  inherit (merged) users home-manager;

  imports = [ ./modules.nix ];

  networking.hostName = "diglett";

  system.stateVersion = "22.11";
}
