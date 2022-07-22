{ pkgs, ... }: {
  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  hardware = {
    enableRedistributableFirmware = true;
    deviceTree.filter = "bcm*-rpi-3-b-plus.dtb";
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_rpi3;
    kernelParams = [ "cma=128M" ];

    initrd = {
      availableKernelModules = [ "mmc_block" "usbhid" "usb_storage" "vc4" ];
    };

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
}
