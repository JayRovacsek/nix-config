{ config, pkgs, ... }:

{
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
