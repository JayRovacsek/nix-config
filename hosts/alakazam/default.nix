{ config, pkgs, lib, flake, ... }:

let
  inherit (flake) common;
  inherit (flake.common.home-manager-module-sets) base hyprland-desktop;
  inherit (flake.lib) merge;

  builder = common.users.builder {
    inherit config pkgs;
    modules = base;
  };

  jay = common.users.jay {
    inherit config pkgs;
    modules = hyprland-desktop;
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

  microvm.vms = {
    # aipom = {
    #   # The package set to use for the microvm. This also determines the microvm's architecture.
    #   # Defaults to the host system's package set if not given.
    #   inherit pkgs;

    #   # (Optional) A set of special arguments to be passed to the MicroVM's NixOS modules.
    #   #specialArgs = {};

    #   # The configuration for the MicroVM.
    #   # Multiple definitions will be merged as expected.
    #   config = {
    #     imports = [ flake.inputs.microvm.nixosModules.microvm ];

    #     # It is highly recommended to share the host's nix-store
    #     # with the VMs to prevent building huge images.
    #     microvm.shares = [{
    #       source = "/nix/store";
    #       mountPoint = "/nix/.ro-store";
    #       tag = "ro-store";
    #       proto = "virtiofs";
    #     }];

    #     # This is necessary to import the host's nix-store database
    #     microvm.writableStoreOverlay = true;

    #     # Any other configuration for your MicroVM
    #     #...
    #   };
    # };
    aipom = import ../aipom { inherit pkgs flake; };
    # igglybuff = import ../igglybuff;
    # inherit aipom igglybuff;
    # aipom = {
    #   inherit flake;
    #   autostart = true;
    # };
    # igglybuff = {
    #   inherit flake;
    #   autostart = true;
    # };
  };

  services.tailscale.tailnet = "admin";

  imports =
    [ ./hardware-configuration.nix ./modules.nix ./system-packages.nix ];

  networking = {
    hostName = "alakazam";
    hostId = "ef26b1be";
    useDHCP = false;
    interfaces.enp0s31f6.useDHCP = true;
  };

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  system.stateVersion = "22.11";
}
