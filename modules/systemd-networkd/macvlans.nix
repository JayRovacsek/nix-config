{ config, pkgs, ... }:
let meta = import ./meta.nix { inherit config; };
in {
  systemd.network.netdevs = {
    "10-macvlan-microvm" = {
      enable = meta.isMicrovmHost;
      netdevConfig = {
        Kind = "macvlan";
        Name = "mvl-microvm";
      };
      macvlanConfig.Mode = "bridge";
      vlanConfig.Id = 20;
    };
  };
}
