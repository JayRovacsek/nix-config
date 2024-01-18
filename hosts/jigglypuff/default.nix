{ config, pkgs, lib, flake, ... }:

let
  inherit (flake) common;
  inherit (flake.common.home-manager-module-sets) cli;
  inherit (flake.lib) merge;

  jay = common.users.jay {
    inherit config pkgs;
    modules = cli;
  };

  merged = merge [ jay ];
in {
  inherit flake;
  inherit (merged) users home-manager;

  imports = [ ./network.nix ];

  age = {
    secrets = {
      "git-signing-key" = rec {
        file = ../../secrets/ssh/git-signing-key.age;
        owner = builtins.head (builtins.attrNames jay.users.users);
        path = "/home/${owner}/.ssh/git-signing-key";
      };

      "git-signing-key.pub" = rec {
        file = ../../secrets/ssh/git-signing-key.pub.age;
        owner = builtins.head (builtins.attrNames jay.users.users);
        path = "/home/${owner}/.ssh/git-signing-key.pub";
      };
    };
    identityPaths = [ "/agenix/id-ed25519-ssh-primary" ];
  };

  boot = {
    kernelParams = [ "cma=128M" ];

    initrd.availableKernelModules =
      [ "mmc_block" "usbhid" "usb_storage" "vc4" ];

    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  hardware.enableRedistributableFirmware = true;

  swapDevices = [{
    device = "/swapfile";
    size = 1024;
  }];

  system.stateVersion = "22.05";
}
