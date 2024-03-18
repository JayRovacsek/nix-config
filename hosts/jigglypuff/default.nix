{ config, pkgs, lib, self, ... }:

let
  inherit (self) common;
  inherit (self.common.home-manager-module-sets) cli;
  inherit (self.lib) merge;

  jay = common.users.jay {
    inherit config pkgs;
    modules = cli;
  };

  merged = merge [ jay ];
in {
  inherit (merged) users home-manager;

  age = {
    secrets = {
      "git-signing-key" = rec {
        file = ../../secrets/ssh/git-signing-key.age;
        owner = builtins.head (builtins.attrNames jay.users.users);
        path = "/home/${owner}/.ssh/git-signing-key";
      };

      "git-signing-key.pub" = rec {
        file = ../../secrets/ssh/git-signing-key.pub.age;
        owner = builtins.head (builtins.attrNames jay.users.users);
        path = "/home/${owner}/.ssh/git-signing-key.pub";
      };
    };
    identityPaths = [ "/agenix/id-ed25519-ssh-primary" ];
  };

  boot = {
    kernelParams = [ "cma=128M" ];

    initrd.availableKernelModules =
      [ "mmc_block" "usbhid" "usb_storage" "vc4" ];

    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  hardware.enableRedistributableFirmware = true;

  networking = {
    hostName = "jigglypuff";
    hostId = "d2a7f613";
    # We're only got a single interface on the pi, so it'll be fine
    # for now to just assume eth0
    usePredictableInterfaceNames = false;
  };

  services.journald.storage = "volatile";

  swapDevices = [{
    device = "/swapfile";
    size = 1024;
  }];

  systemd.network = {
    netdevs."00-vlan-dns" = {
      enable = true;
      netdevConfig = {
        Kind = "vlan";
        Name = "vlan-dns";
      };
      vlanConfig.Id = 6;
    };

    networks = {
      "00-wired" = {
        enable = true;
        # mkForce is utilised here to override the default systemd
        # settings in the systemd-networkd module
        matchConfig.Name = lib.mkForce "eth0";
        networkConfig = lib.mkForce {
          VLAN = config.systemd.network.netdevs."00-vlan-dns".netdevConfig.Name;
        };
        dhcpV4Config = lib.mkForce { };
      };

      "10-vlan-dns" = {
        enable = true;
        name = config.systemd.network.netdevs."00-vlan-dns".netdevConfig.Name;
        networkConfig.DHCP = "ipv4";
      };
    };
  };

  system.stateVersion = "24.05";
}
