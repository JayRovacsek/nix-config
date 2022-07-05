{ config, pkgs, ... }:
let
  userFunction = import ../../functions/map-reduce-users.nix;
  userConfigs = import ./users.nix { inherit config pkgs; };
  generatedUsers = userFunction { inherit userConfigs; };
in {
  ## Todo: rewrite this to add root config in a consistent way with other configs
  users = {
    defaultUserShell = pkgs.zsh;
    users.root = {
      initialHashedPassword =
        "$6$wRRIfT/GbE4O9sCu$4SVNy.ig6x.qFiefE0y/aG4kdbKEdXF23bew7f53tn.ZxBDKra64obi0CoSnwRJBT1p5NlLEXh5m9jhX6.k3a1";
    };
  } // generatedUsers;

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

  imports =
    [ ./hardware-configuration.nix ./modules.nix ./system-packages.nix ];

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  system.stateVersion = "22.11";
}
