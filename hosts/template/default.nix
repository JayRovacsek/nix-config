{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./modules.nix
    ./networking.nix
    ./services.nix
    ./system-packages.nix
    ./users.nix
  ];

  # This assumes we're using GRUB in order to utilise os-prober, otherwise the
  # better option will be boot.loader.systemd-boot
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
    device = "/dev/disk/by-uuid/${uuid}";
    preLVM = true;
  };

  time.timeZone = "Australia/NSW";

  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
  };

  # Previously required for auto-login for a user, need to test & remove if no longer required
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  documentation.man.generateCaches = true;
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
