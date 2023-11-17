{ config, pkgs, lib, modulesPath, flake, ... }:

let
  inherit (flake) common;
  inherit (flake.common.home-manager-module-sets) base desktop;
  inherit (flake.lib) merge;

  builder = common.users.builder {
    inherit config pkgs;
    modules = base;
  };

  jay = common.users.jay {
    inherit config pkgs;
    modules = desktop;
  };

  merged = merge [ builder jay ];

in {
  inherit flake;
  inherit (merged) users home-manager;

  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
    ./hardware-configuration.nix
    ./wireless.nix
  ];

  age.identityPaths =
    [ "/agenix/id-ed25519-ssh-primary" "/agenix/id-ed25519-wireless-primary" ];

  environment.systemPackages = with pkgs; [ jellyfin-media-player ];

  networking = {
    hostName = "wigglytuff";
    hostId = "d2a7b80b";
  };

  system.stateVersion = "23.11";

  # Hide Builder user from SDDM login
  services.xserver.displayManager.sddm.settings.Users.HideUsers = "builder";
}
