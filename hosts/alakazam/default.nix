{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./modules.nix
    ./system-packages.nix
    ./users.nix
  ];

  networking.hostName = "alakazam";

  boot = {
    loader = {
      grub = {
        enable = true;
        version = 2;
        device = "nodev";
        efiSupport = true;
        efiInstallAsRemovable = true;
        useOSProber = true;
        enableCryptodisk = true;
      };
    };
  };

  boot.initrd.luks.devices.crypted = {
    device = "/dev/disk/by-uuid/7cf02c33-9404-45af-9e53-2fa65aa59027";
    preLVM = true;
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
  };

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  system = {
    stateVersion = "22.05";
    autoUpgrade = {
      enable = true;
      dates = "04:00";
      allowReboot = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
  };
}
