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
  };
}
