{ config, pkgs, lib, ... }:
let
  userFunction = import ../../functions/map-reduce-users.nix;
  userConfigs = (import ./users.nix).users;
  users = userFunction { users = userConfigs; };
in {
  inherit users;
  imports =
    [ ./hardware-configuration.nix ./modules.nix ./system-packages.nix ];

  networking.wireless.environmentFile = "/run/secrets/wireless.env";
  networking.wireless = {
    enable = true;
    interfaces = [ "wlan0" ];
    networks."@IOT_SSID@".psk = "@IOT_PSK@";
  };

  networking.hostName = "wigglytuff";
  networking.hostId = "d2a7b80b";
}
