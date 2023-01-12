{ config, pkgs, lib, flake, ... }:
let
  userConfigs = import ./users.nix { inherit config pkgs; };
  users = import ../../functions/map-reduce-users.nix {
    inherit config pkgs lib userConfigs;
  };
in {
  inherit users flake;

  age.identityPaths = [ "/agenix/id-ed25519-ssh-primary" ];

  imports =
    [ ./hardware-configuration.nix ./modules.nix ./system-packages.nix ];

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

  networking.hostName = "gastly";

  system.stateVersion = "22.11";
}

