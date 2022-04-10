{ config, pkgs, ... }:
let
  userFunction = import ../../functions/map-reduce-users.nix;
  userConfigs = (import ./users.nix).users;
  users = userFunction { inherit pkgs userConfigs; };
in {
  inherit users;

  ## Todo: write out the below - need to rework networking module.
  networking = {
    wireless.enable = false;
    hostId = "acd009f4";
    hostName = "dragonite";
    useDHCP = false;
    interfaces.enp9s0.useDHCP = true;

    firewall = {
      allowedTCPPorts = [ 22 80 139 443 445 5900 7200 8200 9000 ];
      allowedUDPPorts = [ 137 138 ];
    };
  };

  imports =
    [ ./hardware-configuration.nix ./modules.nix ./system-packages.nix ];

  system = {
    stateVersion = "22.05";
    autoUpgrade = {
      enable = true;
      dates = "04:00";
      allowReboot = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
  };
}
