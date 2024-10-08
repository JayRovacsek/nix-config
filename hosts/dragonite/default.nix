{
  config,
  pkgs,
  self,
  ...
}:
let
  inherit (self) common;
  inherit (self.lib) merge;

  builder = common.users.builder {
    inherit config pkgs;
    modules = self.common.home-manager-module-sets.base;
  };

  jay = common.users.jay {
    inherit config pkgs;
    modules = with self.common.home-manager-module-sets; cli ++ ssh;
  };

  jellyfin-user = {
    users = {
      extraUsers.jellyfin = {
        createHome = false;
        description = "User account generated for running a specific service";
        group = "jellyfin";
        isSystemUser = true;
        uid = 998;
      };

      groups = self.common.config.services.media.groups // {
        users.gid = 100;

        jellyfin = {
          gid = 10001;
          members = [ "jellyfin" ];
        };

        media.members = [
          "jay"
          "jellyfin"
          "media"
        ];
      };

      inherit (self.common.config.services.media) users;
    };
  };

  user-configs = merge [
    builder
    jay
    jellyfin-user
  ];

in
{
  inherit (user-configs) users home-manager;

  imports = with self.nixosModules; [
    ./backups.nix
    ./disk-config.nix
    ./microvms.nix
    agenix
    blocky
    clamav
    firefox-syncserver
    fonts
    generations
    gnupg
    grafana-agent
    harmonia
    hydra
    i18n
    jellyfin
    jellyseerr
    logging
    lorri
    microvm-host
    nix
    nix-topology
    nvidia
    openssh
    openvscode-server
    remote-builds
    smartd
    ssh
    sudo
    systemd-networkd
    telegraf
    time
    timesyncd
    tmp-tmpfs
    tmux
    udev
    unifi
    zfs
    zramSwap
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
    binfmt.emulatedSystems = [
      "aarch64-linux"
      "armv6l-linux"
      "armv7l-linux"
    ];

    blacklistedKernelModules = [ "e1000e" ];

    extraModprobeConfig = "options vfio-pci ids=8086:105e,8086:105e";

    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "sd_mod"
      ];
      kernelModules = [
        "vfio_virqfd"
        "vfio_pci"
        "vfio_iommu_type1"
        "vfio"
      ];
    };

    kernel.sysctl."vm.swappiness" = 1;
    kernelModules = [
      "vfio_virqfd"
      "vfio_pci"
      "vfio_iommu_type1"
      "vfio"
    ];
    kernelParams = [ "amd_iommu=on" ];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    supportedFilesystems = [
      "ntfs"
      "zfs"
    ];
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

  networking = {
    enableIPv6 = false;
    hostId = "acd009f4";
    hostName = "dragonite";
  };

  powerManagement.enable = false;

  programs.ssh.publicHostKeyBase64 = "ZHJhZ29uaXRlLmxvY2FsIHNzaC1lZDI1NTE5IEFBQUFDM056YUMxbFpESTFOVEU1QUFBQUlQVmtZUkFWY1k1TXNUc3RpTE9sR2g4Zk5TdU1vVFMyWER3cENYeEJFMnYxCg==";

  systemd = {
    network.networks."20-wireless".enable = false;
    services = {
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
    };
  };

  system.stateVersion = "22.11";
}
