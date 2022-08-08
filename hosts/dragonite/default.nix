{ config, pkgs, lib, flake, ... }:
let
  userConfigs = import ./users.nix { inherit config pkgs flake; };
  users = import ../../functions/map-reduce-users.nix {
    inherit config pkgs lib userConfigs;
  };
in {
  inherit users;

  virtualisation.oci-containers.backend = "docker";

  ## Todo: write out the below - need to rework networking module.
  networking = {
    wireless.enable = false;
    hostId = "acd009f4";
    hostName = "dragonite";
    useDHCP = false;
    interfaces.enp9s0.useDHCP = true;

    firewall = {
      ## Todo: remove below as they can be abstracted into microvms
      # For reference:
      # 5900: VNC (need to kill)
      # 8200: Duplicati
      allowedTCPPorts = [ 5900 8200 ];
    };
  };

  imports = [
    ./hardware-configuration.nix
    ./modules.nix
    ./options.nix
    ./system-packages.nix
  ];

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  system.stateVersion = "22.11";
}
