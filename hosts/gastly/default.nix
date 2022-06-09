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

  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      version = 2;
      device = "nodev";
      enableCryptodisk = true;
      efiSupport = true;
    };
  };

  boot.initrd.luks.devices.crypted = {
    device = "/dev/disk/by-uuid/21c13271-a27f-4106-87bb-2ec4c2a043dc";
    preLVM = true;
  };

  networking.hostName = "gastly";

  system.stateVersion = "22.05";
}

