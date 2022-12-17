{ config, pkgs, flake, ... }:
let
  inherit (flake.lib) generate-user-configs;
  inherit (flake.lib) generate-home-manager-configs;

  users = generate-user-configs {
    inherit config pkgs;
    extraModules = [ ];
    users = with flake.users; [ jay ];
  };

  hm-modules = generate-home-manager-configs {
    inherit config pkgs;
    modules = with flake.home-manager-modules; [ alacritty ];
  };
  # userConfigs = import ./users.nix { inherit config pkgs flake; };
  # users = import ../../functions/map-reduce-users.nix {
  #   inherit config pkgs lib userConfigs;
  # };
in {
  inherit flake users;

  age = {
    secrets."tailscale-dns-preauth-key" = {
      file = ../../secrets/tailscale/preauth-dns.age;
      mode = "0400";
    };
    identityPaths = [ "/agenix/id-ed25519-ssh-primary" ];
  };

  services.tailscale.tailnet = "admin";

  imports = [
    ./hardware-configuration.nix
    ./modules.nix
    ./options.nix
    ./system-packages.nix
  ];

  networking = {
    hostName = "alakazam";
    hostId = "ef26b1be";
    useDHCP = false;
    interfaces.enp0s31f6.useDHCP = true;
  };

  microvm.vms = {
    aipom = {
      inherit flake;
      autostart = true;
    };
    igglybuff = {
      inherit flake;
      autostart = true;
    };
  };

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  system.stateVersion = "22.11";
}
