{ config, pkgs, lib, flake, ... }:

let
  inherit (flake) common;
  inherit (flake.common) desktop;
  inherit (flake.lib) merge-user-config;
  jay = common.users.jay {
    inherit config pkgs;
    modules = desktop;
  };

  merged = merge-user-config { users = [ jay ]; };

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

  services.tailscale.tailnet = "admin";

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
