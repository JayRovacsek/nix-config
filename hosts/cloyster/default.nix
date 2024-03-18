{ config, pkgs, lib, self, ... }:

let
  inherit (self.common.home-manager-module-sets) hyprland-desktop;
  inherit (self.lib) merge;

  jay = self.common.users.jay {
    inherit config pkgs;
    modules = hyprland-desktop;
  };

  merged = merge [ jay ];

in {
  inherit (merged) users home-manager;

  age = {
    secrets = {
      "git-signing-key" = rec {
        file = ../../secrets/ssh/git-signing-key.age;
        owner = builtins.head (builtins.attrNames jay.users.users);
        path = "/home/${owner}/.ssh/git-signing-key";
      };

      "git-signing-key.pub" = rec {
        file = ../../secrets/ssh/git-signing-key.pub.age;
        owner = builtins.head (builtins.attrNames jay.users.users);
        path = "/home/${owner}/.ssh/git-signing-key.pub";
      };
    };
    identityPaths = [ "/agenix/id-ed25519-ssh-primary" ];
  };

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

  environment.systemPackages = with pkgs; [
    # CLI
    curl
    wget
    agenix
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/eec72e34-3f63-4bae-bbc4-3f1f81d6fb96";
      fsType = "ext4";
    };
    "/boot/efi" = {
      device = "/dev/disk/by-uuid/5F66-17ED";
      fsType = "vfat";
    };
  };

  hardware = {
    cpu.intel.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;
    firmware = [ self.packages.${pkgs.system}.t2-firmware ];
  };

  networking.hostName = "cloyster";

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  swapDevices =
    [{ device = "/dev/disk/by-uuid/f7990683-8a69-46ad-a5c4-cbac8d212ffb"; }];

  system.stateVersion = "23.11";
}

