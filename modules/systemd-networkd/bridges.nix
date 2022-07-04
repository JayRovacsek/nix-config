{ config, pkgs, ... }:
let meta = import ./meta.nix { inherit config; };
in {
  systemd.network.netdevs = {
    "10-dns" = {
      enable = meta.isMicrovmHost;
      netdevConfig = {
        Kind = "bridge";
        Name = "br-dns";
      };
    };
  };
}
