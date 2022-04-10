{ config, pkgs, ... }:
let
  userFunction = import ../../functions/map-reduce-users.nix;
  userConfigs = (import ./users.nix).users;
  generatedUsers = userFunction { inherit pkgs userConfigs; };
in {
  ## Todo: rewrite this to add root config in a consistent way with other configs
  users = {
    defaultUserShell = pkgs.zsh;
    mutableUsers = false;
    users.root = {
      hashedPassword =
        "$6$wRRIfT/GbE4O9sCu$4SVNy.ig6x.qFiefE0y/aG4kdbKEdXF23bew7f53tn.ZxBDKra64obi0CoSnwRJBT1p5NlLEXh5m9jhX6.k3a1";
    };
  } // generatedUsers;

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

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

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
