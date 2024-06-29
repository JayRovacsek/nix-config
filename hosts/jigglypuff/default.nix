{ config, pkgs, lib, self, ... }:

let
  inherit (self) common;
  inherit (self.common.home-manager-module-sets) cli;
  inherit (self.lib) merge;

  jay = common.users.jay {
    inherit config pkgs;
    modules = cli ++ self.common.home-manager-module-sets.impermanence;
  };

  user-configs = merge [ jay ];
in {
  inherit (user-configs) users home-manager;

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
    "/persistent" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      neededForBoot = true;
    };
  };

  hardware.enableRedistributableFirmware = true;

  imports = with self.nixosModules; [
    agenix
    blocky
    fonts
    generations
    gnupg
    grafana-agent
    impermanence
    journald
    logging
    nix
    nix-topology
    openssh
    sudo
    systemd-networkd
    time
    timesyncd
    zsh
  ];
  # Add the below to enable imaging as a SD image - this
  # causes issues when impermanence is active however
  # ref: https://github.com/NixOS/nixpkgs/blob/53a702e155d4d87cb908524ddb52db36aed98d03/nixos/modules/installer/sd-card/sd-image.nix#L165
  # ++ [
  #  "${self.inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
  # ];

  networking = {
    hostName = "jigglypuff";
    hostId = "d2a7f613";
    # We're only got a single interface on the pi, so it'll be fine
    # for now to just assume eth0
    usePredictableInterfaceNames = false;
  };

  swapDevices = [{
    device = "/swapfile";
    size = 256;
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
