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

  imports =
    [ ./hardware-configuration.nix ./modules.nix ./system-packages.nix ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      device = "nodev";
      enableCryptodisk = true;
      efiSupport = true;
    };
  };

  networking.hostName = "cloyster";

  system.stateVersion = "23.11";
}

