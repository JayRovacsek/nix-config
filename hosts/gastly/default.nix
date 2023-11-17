{ config, pkgs, lib, flake, ... }:

let
  inherit (flake) common;
  inherit (flake.common.home-manager-module-sets) gnome-desktop games;
  inherit (flake.lib) merge;

  modules = gnome-desktop ++ games;

  jay = common.users.jay { inherit config pkgs modules; };

  sarah = common.users.sarah { inherit config pkgs modules; };

  merged = merge [ jay sarah ];

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

  imports = [ ./hardware-configuration.nix ./system-packages.nix ];

  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "gastly";
    useDHCP = true;
    wireless = {
      enable = true;
      # TODO agenix when I get a moment
      environmentFile = "/secrets/wpa.conf";
      interfaces = [ "wlp58s0" ];
      networks = {
        "@HOME_SSID@" = {
          psk = "@HOME_PSK@";
          priority = 10;
          authProtocols = [ "WPA-PSK" ];
        };

        "@HOTSPOT_SSID@" = {
          psk = "@HOTSPOT_PSK@";
          priority = 20;
          authProtocols = [ "WPA-PSK" ];
        };

        "@SARAH_HOTSPOT_SSID@" = {
          psk = "@SARAH_HOTSPOT_PSK@";
          priority = 50;
          authProtocols = [ "WPA-PSK" ];
        };
      };
    };
  };

  system.stateVersion = "22.11";
}

