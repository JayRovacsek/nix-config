{ pkgs, ... }: {
  hardware = {
    enableRedistributableFirmware = true;
    deviceTree.filter = "bcm*-rpi-3-b-plus.dtb";
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_rpi3;
    kernelParams = [ "cma=128M" ];

    initrd = {
      kernelModules = [
        "genet"
        "lan78xx"
        "pcie_brcmstb"
        "broadcom"
        "vc4"
        "v3d"
        "reset_raspberrypi"
        "xhci_pci"
        "sd_mod"
        "usbhid"
        "hid_generic"
        "hid_microsoft"
      ];
      availableKernelModules =
        [ "xhci_pci" "xhci_hcd" "uas" "usb_storage" "mmc_block" "usbhid" ];
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
