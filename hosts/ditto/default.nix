{ config, pkgs, flake, provider, ... }:

let
  inherit (pkgs) system;
  inherit (flake) common;
  inherit (flake.common.home-manager-module-sets) minimal-cli;
  inherit (flake.lib) merge-user-config;

  inherit (flake.packages.${system}) ditto-transform;

  jay = common.users.jay {
    inherit config pkgs;
    modules = minimal-cli;
  };

  merged = merge-user-config { users = [ jay ]; };
in {
  inherit flake;
  inherit (merged) users home-manager;

  environment.systemPackages = [ ditto-transform ];

  imports = [ ./modules.nix ./system-packages.nix ];

  networking.hostName = "ditto";

  system.stateVersion = "22.11";
}
