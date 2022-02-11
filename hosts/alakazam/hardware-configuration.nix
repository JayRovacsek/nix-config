{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/e78b4f61-9844-4cb3-a144-ff8f8dd37154";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/3BA7-CA2B";
    fsType = "vfat";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/b8d2e5ee-095e-4daa-8b2b-ddcfc5b67ac9"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
