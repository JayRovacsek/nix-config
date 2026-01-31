{
  config,
  pkgs,
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

  hardware = {
    deviceTree.name = "rockchip/rk3588-orangepi-5-plus.dtb";

    firmware = [
      self.packages.${pkgs.system}.orangepi-firmware
    ];
  };

  boot = {
    loader =
      let
        extraInstallCommands = ''
          ${pkgs.coreutils}/bin/mkdir -p /boot/dtb/base
          ${pkgs.coreutils}/bin/cp -r ${config.hardware.deviceTree.package}/rockchip/* /boot/dtb/base/
          ${pkgs.coreutils}/bin/sync
        '';
      in
      {
        systemd-boot = {
          enable = true;
          inherit extraInstallCommands;
        };
        grub.extraInstallCommands = extraInstallCommands;
        efi.canTouchEfiVariables = true;
      };
    kernelParams = [
      "rootwait"

      "earlycon" # enable early console, so we can see the boot messages via serial port / HDMI
      "consoleblank=0" # disable console blanking(screen saver)
      "console=ttyS2,1500000" # serial port
      "console=tty1" # HDMI

      # docker optimisations
      "cgroup_enable=cpuset"
      "cgroup_memory=1"
      "cgroup_enable=memory"
      "swapaccount=1"
    ];

    initrd.availableKernelModules = [
      "nvme"
      "mmc_block"
    ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/f222513b-ded1-49fa-b591-20ce86a2fe7f";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/12CE-A600";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };

  imports =
    (with self.nixosModules; [
      # ./disk-config.nix
      alloy
      blocky
      fonts
      generations
      gnupg
      # impermanence
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
    ])
    ++ (with self.inputs.nixos-generators.nixosModules; [
      # all-formats
      # raw-efi
    ]);

  networking.hostName = "onix";

  system.stateVersion = "25.11";
}
