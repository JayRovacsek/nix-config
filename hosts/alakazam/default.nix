{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./modules.nix
    ./networking.nix
    ./services.nix
    ./system-packages.nix
    ./users.nix
  ];

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

  time.timeZone = "Australia/NSW";

  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
    nvidia = { modesetting.enable = true; };
  };

  nix = {
    gc = {
      automatic = true;
      dates = "monthly";
      options = "--delete-older-than 7d";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
    settings = {
      trusted-users = [ "jay" "root" ];
      auto-optimise-store = true;
    };

    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

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
