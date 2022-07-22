{ pkgs, ... }: {
  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  hardware.enableRedistributableFirmware = true;

  boot = {
    kernelPackages = pkgs.linuxPackages_rpi3;
    kernelParams = [ "cma=128M" ];

    initrd = {
      availableKernelModules = [ "mmc_block" "usbhid" "usb_storage" "vc4" ];
    };

    loader = {
      grub.enable = false;
      generic-extlinux-compatible = true;
    };
  };
}
