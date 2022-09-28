{ config, pkgs, lib, flake, ... }:
let
  userConfigs = import ./users.nix { inherit config pkgs; };
  users = import ../../functions/map-reduce-users.nix {
    inherit config pkgs lib userConfigs;
  };
in {
  inherit users flake;

  services.tailscale.tailnet = "admin";

  imports = [
    ./hardware-configuration.nix
    ./modules.nix
    ./options.nix
    ./system-packages.nix
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

  system.stateVersion = "22.11";
}

