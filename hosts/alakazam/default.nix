{ config, pkgs, lib, flake, ... }:

let
  inherit (flake) common;
  inherit (flake.common.home-manager-module-sets) linux-desktop;
  inherit (flake.lib) merge-user-config;

  builder = common.users.builder {
    inherit config pkgs;
    modules = [ ];
  };

  jay = common.users.jay {
    inherit config pkgs;
    modules = linux-desktop;
  };

  merged = merge-user-config { users = [ builder jay ]; };

in {
  inherit flake;
  inherit (merged) users home-manager;

  age = {
    secrets."tailscale-dns-preauth-key" = {
      file = ../../secrets/tailscale/preauth-dns.age;
      mode = "0400";
    };
    identityPaths = [ "/agenix/id-ed25519-ssh-primary" ];
  };

  # microvm.vms = {
  #   aipom = {
  #     inherit flake;
  #     autostart = true;
  #   };
  #   igglybuff = {
  #     inherit flake;
  #     autostart = true;
  #   };
  # };

  # services.tailscale.tailnet = "admin";

  imports =
    [ ./hardware-configuration.nix ./modules.nix ./system-packages.nix ];

  networking = {
    hostName = "alakazam";
    hostId = "ef26b1be";
    useDHCP = false;
    interfaces.enp0s31f6.useDHCP = true;
  };

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  system.stateVersion = "22.11";
}
