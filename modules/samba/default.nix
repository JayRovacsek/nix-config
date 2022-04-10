{ config, pkgs, ... }:
let
  hostname = config.networking.hostName;
  sambaConfig = import ./. + "/configs/${hostname}.nix";
in { services.samba = sambaConfig; }
