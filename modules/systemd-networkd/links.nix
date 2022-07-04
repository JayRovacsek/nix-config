{ config, pkgs, ... }:
let meta = import ./meta.nix { inherit config; };
in {
  systemd.network.links = {
    "10-phys0" = {
      matchConfig = {
        PermanentMACAddress = "4c:cc:6a:4a:12:f6";
        Virtualization = "no";
      };
      linkConfig.Name = "phys0";
    };
  };
}
