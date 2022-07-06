{ config, pkgs, ... }:
let meta = import ./meta.nix { inherit config; };
in {
  systemd.network.netdevs = {
    "vlan-dns" = {
      enable = meta.isMicrovmHost;
      netdevConfig = {
        Kind = "vlan";
        Name = "vlan-dns";
      };
      vlanConfig.Id = 6;
    };

    "vlan-microvm" = {
      enable = meta.isMicrovmHost;
      netdevConfig = {
        Kind = "vlan";
        Name = "vlan-microvm";
      };
      vlanConfig.Id = 6;
    };
  };
}
