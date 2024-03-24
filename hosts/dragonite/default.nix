{ config, pkgs, lib, self, ... }:
let
  inherit (self) common;
  inherit (self.common.home-manager-module-sets) base cli;
  inherit (self.lib) merge;

  builder = common.users.builder {
    inherit config pkgs;
    modules = base;
  };

  jay = common.users.jay {
    inherit config pkgs;
    modules = cli;
  };

  user-configs = merge [ builder jay ];

in {
  inherit (user-configs) users home-manager;

  imports = with self.nixosModules; [
    ./filesystems.nix
    ./old-users.nix
    agenix
    blocky
    clamav
    firefox-syncserver
    fonts
    gids
    gnupg
    hydra
    jellyfin
    jellyseerr
    lorri
    microvm-host
    nix
    nix-serve
    nvidia
    openssh
    openvscode-server
    samba
    sudo
    systemd-networkd
    time
    timesyncd
    udev
    uids
    zfs
    zsh
  ];

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
    binfmt.emulatedSystems = [ "aarch64-linux" "armv6l-linux" "armv7l-linux" ];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    blacklistedKernelModules = [ "e1000e" ];

    supportedFilesystems = [ "ntfs" "zfs" ];
    kernelParams = [ "amd_iommu=on" ];

    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "sd_mod" ];
      kernelModules = [ "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];
    };

    kernelModules = [ "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];
    extraModprobeConfig = "options vfio-pci ids=8086:105e,8086:105e";
  };

  environment.systemPackages = with pkgs; [
    cifs-utils
    dnsutils
    exfat
    hddtemp
    htop
    lm_sensors
    pciutils
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/910a3375-cfe7-4c14-a6ec-5f2c1306548a";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/0372-A22D";
      fsType = "vfat";
    };
  };

  hardware.cpu = {
    profile = {
      cores = 24;
      speed = 4;
    };
    amd.updateMicrocode = true;
  };

  microvm = {
    macvlans = [
      {
        name = "guest";
        parent = "10-wired";
        vlan-tag = 2;
      }
      {
        name = "iot";
        parent = "10-wired";
        vlan-tag = 3;
      }
      {
        name = "download";
        parent = "10-wired";
        vlan-tag = 4;
      }
      {
        name = "reverse-proxy";
        parent = "10-wired";
        vlan-tag = 5;
      }
      {
        name = "dns";
        parent = "10-wired";
        vlan-tag = 6;
      }
      {
        name = "work";
        parent = "10-wired";
        vlan-tag = 7;
      }
      {
        name = "wlan";
        parent = "10-wired";
        vlan-tag = 8;
      }
      {
        name = "authelia";
        parent = "10-wired";
        vlan-tag = 9;
      }
      {
        name = "nextcloud";
        parent = "10-wired";
        vlan-tag = 10;
      }
      {
        name = "cache";
        parent = "10-wired";
        vlan-tag = 16;
      }
      {
        name = "game";
        parent = "10-wired";
        vlan-tag = 17;
      }
      {
        name = "headscale";
        parent = "10-wired";
        vlan-tag = 25;
      }
    ];

    vms = let
      party = [
        "bellsprout"
        "igglybuff"
        "machop"
        "magikarp"
        "mankey"
        "meowth"
        "nidoking"
        "nidorina"
        "nidorino"
        "poliwag"
        "porygon"
      ];
    in builtins.foldl' (acc: pokemon:
      acc // {
        ${pokemon} = {
          flake = self;
          restartIfChanged = true;
        };
      }) { } party;
  };

  networking = {
    hostId = "acd009f4";
    hostName = "dragonite";
  };

  powerManagement.enable = false;

  services = {
    # This requires the addition of the samba module
    # to enable shares
    samba.shares = {
      isos = {
        path = "/srv/isos";
        browseable = "yes";
        "read only" = true;
        "guest ok" = "yes";
        comment = "Public ISO Share";
      };
      games = {
        path = "/srv/games/files";
        browseable = "yes";
        "read only" = true;
        "guest ok" = "yes";
        comment = "Public Game Files";
      };
    };
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/de692380-3788-4375-8afb-33a6195fa9e6"; }];

  systemd = {
    network.networks."20-wireless".enable = false;
    services = {
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
    };
  };

  system.stateVersion = "22.11";
}
