{ config, pkgs, lib, self, ... }:
let
  inherit (self) common;
  inherit (self.common.home-manager-module-sets) darwin-desktop;
  inherit (self.lib) merge;

  jay = common.users."jrovacsek" {
    inherit config pkgs;
    modules = darwin-desktop;
  };
  merged = merge [ jay ];
in {
  inherit (merged) users home-manager;

  imports = [ ./system-packages.nix ./secrets.nix ];

  services.nix-daemon.enable = true;

  networking = {
    computerName = "ninetales";
    hostName = "ninetales";
    localHostName = "ninetales";
  };

  system.stateVersion = 4;
}
