{
  config,
  pkgs,
  lib,
  self,
  ...
}:
let
  inherit (self) common;
  inherit (self.common.home-manager-module-sets) darwin-desktop;
  inherit (self.lib) merge;

  jay = common.users."jrovacsek" {
    inherit config pkgs;
    modules = darwin-desktop;
  };
  user-configs = merge [ jay ];
in
{
  inherit (user-configs) users home-manager;

  imports = [
    ./modules.nix
    ./system-packages.nix
    ./secrets.nix
  ];

  services.nix-daemon.enable = true;

  networking = {
    computerName = "cloyster";
    hostName = "cloyster";
    localHostName = "cloyster";
  };

  system.stateVersion = 4;
}
