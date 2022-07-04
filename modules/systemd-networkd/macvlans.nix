{ config, pkgs, ... }:
let meta = import ./meta.nix { inherit config; };
in {
  systemd.network.netdevs = {
    "10-mvl-dns" = {
      enable = meta.isMicrovmHost;
      netdevConfig = {
        Kind = "macvlan";
        Name = "mvl-dns";
      };
      macvlanConfig.Mode = "bridge";
      vlanConfig.Id = 6;
    };
  };
}
