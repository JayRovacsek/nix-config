{ config, pkgs, lib, flake, ... }:

let
  inherit (flake) common;
  inherit (flake.lib) merge-user-config;

  test = common.users.test {
    inherit config pkgs;
    modules = [ ];
  };

  merged = merge-user-config { users = [ test ]; };

in {
  inherit flake;
  inherit (merged) users home-manager;

  # Enable auto-login for testing
  services.xserver.displayManager.autoLogin = {
    enable = true;
    user = "test";
  };

  imports = [ ./modules.nix ./system-packages.nix ];

  networking = {
    hostName = "mew";
    useDHCP = true;
  };

  system.stateVersion = "22.11";
}
