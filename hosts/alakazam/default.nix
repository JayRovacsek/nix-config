{ config, pkgs, lib, flake, ... }:

let
  inherit (flake) common;
  inherit (flake.common.home-manager-module-sets) base hyprland-games-desktop;
  inherit (flake.lib) merge;

  inherit (pkgs) system;
  inherit (config.flake.packages.${system}) trdsql;

  builder = common.users.builder {
    inherit config pkgs;
    modules = base;
  };

  jay = common.users.jay {
    inherit config pkgs;
    modules = hyprland-games-desktop;
  };

  merged = merge [ builder jay ];

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

      "terraform-api-key" = rec {
        file = ../../secrets/terraform/terraform-api-key.age;
        owner = builtins.head (builtins.attrNames jay.users.users);
        mode = "400";
        path = "/home/${owner}/.terraform.d/credentials.tfrc.json";
      };
    };
    identityPaths = [
      "/agenix/id-ed25519-ssh-primary"
      "/agenix/id-ed25519-terraform-primary"
    ];
  };

  environment.systemPackages = (with pkgs; [ curl wget agenix ]) ++ [ trdsql ];

  hardware.opengl.driSupport32Bit = true;

  imports = [ ./hardware-configuration.nix ];

  networking = {
    hostId = "ef26b1be";
    hostName = "alakazam";
    useDHCP = false;
  };

  services.tailscale.tailnet = "admin";

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
  system.stateVersion = "22.11";
}
