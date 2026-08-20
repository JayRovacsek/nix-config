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

  boot = {
    kernelPackages = pkgs.linuxPackages_6_18;
    initrd.allowMissingModules =
      !config.boot.kernelPackages.kernel.configfile.autoModules;
    kernelParams = [
      "net.ifnames=0"
      "console=tty1"
      "earlycon"
    ];
    loader = {
      grub.enable = false;
      systemd-boot.enable = true;
    };

    initrd.availableKernelModules = [
      "nvme"
      "mmc_block"
    ];

    growPartition = true;
  };

  hardware.deviceTree.name = "rockchip/rk3588-orangepi-5-plus.dtb";

  imports = with self.nixosModules; [
    ./disk-config.nix
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
  ];

  networking.hostName = "onix";

  system.stateVersion = "26.05";
}
