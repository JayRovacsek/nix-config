{ lib, ... }: {
  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" "armv7l-linux" ];
    extraModulePackages = [ ];
    initrd = {
      availableKernelModules =
        [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ "dm-snapshot" ];
      luks.devices.crypted = {
        device = "/dev/disk/by-uuid/7cf02c33-9404-45af-9e53-2fa65aa59027";
        preLVM = true;
      };
    };
    kernelModules = [ "kvm-intel" ];
  };

  hardware.cpu = {
    intel.updateMicrocode = true;
    profile = {
      cores = 8;
      speed = 2;
    };
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/3BA7-CA2B";
      fsType = "vfat";
      neededForBoot = true;
    };
    "/persistent" = {
      device = "/dev/disk/by-uuid/e78b4f61-9844-4cb3-a144-ff8f8dd37154";
      fsType = "ext4";
      neededForBoot = true;
    };
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/b8d2e5ee-095e-4daa-8b2b-ddcfc5b67ac9"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
