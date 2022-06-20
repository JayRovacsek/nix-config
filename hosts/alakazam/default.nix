{ config, pkgs, ... }:
let
  userFunction = import ../../functions/map-reduce-users.nix;
  userConfigs = import ./users.nix;
  users = userFunction { inherit pkgs userConfigs; };
in {
  inherit users;

  imports = [
    ./hardware-configuration.nix
    ./modules.nix
    ./system-packages.nix
    ./secrets.nix
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

  system.stateVersion = "22.11";
}
