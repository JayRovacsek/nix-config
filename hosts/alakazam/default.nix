{ config, pkgs, lib, flake, ... }:
let
  userConfigs = import ./users.nix { inherit config pkgs flake; };
  users = import ../../functions/map-reduce-users.nix {
    inherit config pkgs lib userConfigs;
  };
in {
  inherit users;

  imports = [
    ./hardware-configuration.nix
    (import ./modules.nix { inherit config pkgs lib flake; })
    ./options.nix
    ./system-packages.nix
  ];

  networking = {
    hostName = "alakazam";
    hostId = "ef26b1be";
  };

  microvm.vms = {
    aipom = {
    inherit flake;
    autostart = true;
    };
    igglybuff = {
      inherit flake;
      autostart = true;
    };
  };

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
