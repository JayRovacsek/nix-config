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
    ./disk-config.nix
    ./old-users.nix
    agenix
    auto-upgrade
    blocky
    clamav
    nix-topology
    firefox-syncserver
    fonts
    generations
    gnupg
    grafana-agent
    hydra
    i18n
    jellyfin
    jellyseerr
    logging
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
    telegraf
    time
    timesyncd
    tmux
    udev
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

    blacklistedKernelModules = [ "e1000e" ];

    extraModprobeConfig = "options vfio-pci ids=8086:105e,8086:105e";

    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "sd_mod" ];
      kernelModules = [ "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];
    };

    kernel.sysctl."vm.swappiness" = 10;
    kernelModules = [ "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];
    kernelParams = [ "amd_iommu=on" ];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    supportedFilesystems = [ "ntfs" "zfs" ];
  };

  environment.systemPackages = with pkgs; [
    agenix
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
    macvlans = builtins.map (vlan: vlan // { parent = "10-wired"; })
      self.common.networking.vlans;

    vms = let
      party = [
        "bellsprout"
        "igglybuff"
        "machop"
        "magikarp"
        "mankey"
        "meowth"
        "mr-mime"
        "nidoking"
        "nidorina"
        "nidorino"
        "poliwag"
        "porygon"
        "slowpoke"
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
