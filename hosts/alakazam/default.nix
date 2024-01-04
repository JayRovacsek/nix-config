{ config, pkgs, lib, flake, ... }:

let
  inherit (flake) common;
  inherit (flake.common.home-manager-module-sets)
    base hyprland-waybar-desktop games;
  inherit (flake.lib) merge;

  inherit (pkgs) system;
  inherit (config.flake.packages.${system}) trdsql;

  builder = common.users.builder {
    inherit config pkgs;
    modules = base;
  };

  jay = common.users.jay {
    inherit config pkgs;
    modules = hyprland-waybar-desktop ++ games;
  };

  merged = merge [ builder jay ];

in {
  inherit flake;
  inherit (merged) users home-manager;

  systemd.services = {
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
  };

  microvm = {
    macvlans = [
      {
        name = "vlan-download";
        parent = "10-wired";
        vlan-tag = 4;
      }
      {
        name = "vlan-dns";
        parent = "10-wired";
        vlan-tag = 6;
      }
    ];
    vms = {
      igglybuff = {
        inherit flake;
        updateFlake = "git+file://${flake}";
      };
    };
  };

  nix.settings = {
    substituters = [ "https://microvm.cachix.org/" ];
    trusted-public-keys =
      [ "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys=" ];
  };

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

  environment.systemPackages = (with pkgs; [ curl wget agenix prismlauncher ])
    ++ [ trdsql ];

  hardware.opengl.driSupport32Bit = true;

  imports = [ ./hardware-configuration.nix ];

  networking = {
    hostId = "ef26b1be";
    hostName = "alakazam";
  };

  services.tailscale.tailnet = "admin";

  system.stateVersion = "22.11";
}
