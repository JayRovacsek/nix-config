{ config, pkgs, ... }:

{
  imports = [ ./modules.nix ./system-packages.nix ./secrets.nix ];

  services.nix-daemon.enable = true;

  networking = {
    computerName = "cloyster";
    hostName = "cloyster";
    localHostName = "cloyster";
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = 4;
}
