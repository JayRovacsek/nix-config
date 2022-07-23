{ config, pkgs, ... }:
let meta = import ./meta.nix { inherit config; };
in {
  systemd.network.links = {
    "10-phys0" = {
      enable = meta.isMicrovmHost;
      matchConfig = {
        Name = "en*";
        Virtualization = "no";
      };
      linkConfig.Name = "phys0";
    };
  };
}
