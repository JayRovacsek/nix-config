{ config, lib, pkgs, modulesPath, ... }:
let inherit (pkgs) system;
in {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    extraModulePackages = [ ];
    initrd = {
      availableKernelModules =
        [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-intel" ];

    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/eec72e34-3f63-4bae-bbc4-3f1f81d6fb96";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/5F66-17ED";
    fsType = "vfat";
  };

  hardware.firmware = [ config.flake.packages.${system}.t2-firmware ];

  swapDevices =
    [{ device = "/dev/disk/by-uuid/f7990683-8a69-46ad-a5c4-cbac8d212ffb"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
