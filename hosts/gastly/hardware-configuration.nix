{ config, lib, ... }: {
  boot = {
    extraModulePackages = [ ];

    initrd = {
      availableKernelModules =
        [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ "dm-snapshot" ];
      luks.devices.crypted = {
        device = "/dev/disk/by-uuid/21c13271-a27f-4106-87bb-2ec4c2a043dc";
        preLVM = true;
      };
    };
    kernelModules = [ "kvm-intel" ];

    loader.efi.canTouchEfiVariables = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/6fa51786-dfec-48eb-9380-559d3980da5c";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/4D3E-FB0A";
      fsType = "vfat";
    };
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/907b7556-218a-4516-ae2b-0b310d6b0b19"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
