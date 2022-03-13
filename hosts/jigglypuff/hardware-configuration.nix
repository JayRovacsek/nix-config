{ pkgs, ... }: {
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  boot.loader.grub.enable = false;

  boot.loader.raspberryPi = {
    enable = true;
    version = 3;
    uboot.enable = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  swapDevices = [{
    device = "/swapfile";
    size = 1024;
  }];
}
