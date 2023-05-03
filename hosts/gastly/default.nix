{ config, pkgs, lib, flake, ... }:

let
  inherit (flake) common;
  inherit (flake.common.home-manager-module-sets) hyprland-desktop;
  inherit (flake.lib) merge;

  jay = common.users.jay {
    inherit config pkgs;
    modules = hyprland-desktop;
  };

  merged = merge [ jay ];

in {
  inherit flake;
  inherit (merged) users home-manager;

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

