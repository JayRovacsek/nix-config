{ lib, pkgs, ... }:
let
  inherit (pkgs.stdenv) isLinux isDarwin;

  linux-settings = lib.optionalAttrs isLinux {
    useDHCP = false;
    networkmanager.enable = true;
  };

  darwin-settings = lib.optionalAttrs isDarwin {
    knownNetworkServices = [ "Wi-Fi" "USB 10/100/1000 LAN" ];
  };

  cfg.networking = linux-settings // darwin-settings;

in cfg
