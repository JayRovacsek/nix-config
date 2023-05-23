{ config, pkgs, lib, flake, ... }:

let
  inherit (flake) common;
  inherit (flake.common.home-manager-module-sets) base hyprland-desktop-minimal;
  inherit (flake.lib) merge;

  builder = common.users.builder {
    inherit config pkgs;
    modules = base;
  };

  jay = common.users.jay {
    inherit config pkgs;
    modules = hyprland-desktop-minimal;
  };

  merged = merge [ builder jay ];

in {
  inherit flake;
  inherit (merged) users home-manager;

  services.xserver.displayManager.autoLogin = {
    enable = true;
    user = "jay";
  };

  imports = [ ./hardware-configuration.nix ./modules.nix ./wireless.nix ];

  environment.systemPackages = with pkgs; [ libraspberrypi ];

  # Add wireless key to identity path
  age.identityPaths =
    [ "/agenix/id-ed25519-ssh-primary" "/agenix/id-ed25519-wireless-primary" ];

  networking.hostName = "wigglytuff";
  networking.hostId = "d2a7b80b";
  system.stateVersion = "22.05";
}
