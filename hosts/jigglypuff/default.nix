{
  config,
  pkgs,
  lib,
  self,
  ...
}:

let
  inherit (self) common;
  inherit (self.common.home-manager-module-sets) cli;
  inherit (self.lib) merge;

  jay = common.users.jay {
    inherit config pkgs;
    modules = cli;
  };

  user-configs = merge [ jay ];
in
{
  inherit (user-configs) users home-manager;

  boot = {
    kernelParams = [ "cma=128M" ];

    kernelPackages = lib.mkDefault pkgs.linuxKernel.packages.linux_rpi3;

    initrd.availableKernelModules = [
      "mmc_block"
      "usbhid"
      "usb_storage"
      "vc4"
    ];

    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };

    supportedFilesystems = {
      btrfs = lib.mkForce false;
      zfs = lib.mkForce false;
    };
  };

  hardware.enableRedistributableFirmware = true;

  imports = with self.nixosModules; [
    ./disk-config.nix
    alloy
    blocky
    fonts
    generations
    gnupg
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
    zramSwap
    zsh
  ];

  networking = {
    hostName = "jigglypuff";
    hostId = "d2a7f613";
    # We're only got a single interface on the pi, so it'll be fine
    # for now to just assume eth0
    usePredictableInterfaceNames = false;
  };

  programs.fuse.userAllowOther = true;

  services.timesyncd.servers = lib.mkForce [
    "137.92.140.80" # -> ntp.ise.canberra.edu.au
    "138.194.21.154" # -> ntp.mel.nml.csiro.au
    "129.6.15.28" # -> time-a-g.nist.gov
    "129.6.15.29" # -> time-b-g.nist.gov
  ];

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
