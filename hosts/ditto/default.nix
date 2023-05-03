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

  environment.systemPackages = [ ditto-transform ] ++ (with pkgs; [ git ]);

  imports = [ ./modules.nix ./system-packages.nix ];

  networking.hostName = "ditto";

  system.stateVersion = "22.11";
}
