{ config, pkgs, flake, ... }:
let
  inherit (pkgs) system;
  inherit (flake) common;
  inherit (flake.common.home-manager-module-sets) cli;
  inherit (flake.lib) merge;

  inherit (flake.packages.${system}) ditto-transform;

  jay = common.users.jay {
    inherit config pkgs;
    modules = cli;
  };

  merged = merge [ jay ];
in {
  inherit flake;
  inherit (merged) users home-manager;

  # Once a ditto, always a ditto.
  environment.systemPackages = [ ditto-transform ] ++ (with pkgs; [ git ]);

  imports = [ ./modules.nix ];

  networking.hostName = "butterfree";

  system.stateVersion = "23.05";
}