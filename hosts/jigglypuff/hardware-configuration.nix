{ pkgs, ... }: {
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  boot.kernelModules = [ "bcm2835-v4l2" ];
  boot.initrd.kernelModules = [ "vc4" "bcm2835_dma" "i2c_bcm2835" ];

  boot = {

    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "cma=128M" ];

    loader = {
      grub.enable = false;
      raspberryPi = {
        enable = true;
        version = 3;
        uboot.enable = true;
        firmwareConfig = ''
          gpu_mem=256
        '';
      };
    };
  };

  hardware.enableRedistributableFirmware = true;

  swapDevices = [{
    device = "/swapfile";
    size = 1024;
  }];
}
