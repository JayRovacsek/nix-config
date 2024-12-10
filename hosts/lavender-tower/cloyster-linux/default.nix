{
  config,
  pkgs,
  lib,
  self,
  ...
}:

let
  inherit (self.common.home-manager-module-sets) hyprland-waybar-desktop;
  inherit (self.lib) merge;

  jay = self.common.users.jay {
    inherit config pkgs;
    modules = hyprland-waybar-desktop;
  };

  user-configs = merge [ jay ];

in
{
  inherit (user-configs) users home-manager;

  boot = {
    extraModulePackages = [ ];
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
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
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  imports =
    (with self.nixosModules; [
      agenix
      clamav
      grafana-agent
      nix-topology
      fonts
      generations
      gnupg
      greetd
      hyprland
      lorri
      nix
      openssh
      steam
      systemd-networkd
      time
      timesyncd
      udev
      zsh
    ])
    ++ [ self.inputs.nixos-hardware.nixosModules.apple-t2 ];

  networking.hostName = "cloyster";

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  swapDevices = [
    { device = "/dev/disk/by-uuid/f7990683-8a69-46ad-a5c4-cbac8d212ffb"; }
  ];

  system.stateVersion = "23.11";
}
