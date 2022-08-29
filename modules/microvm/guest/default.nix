{ config, flake, lib, ... }:
let meta = import ../meta.nix { inherit config flake; };
in {
  networking.useNetworkd = true;

  systemd.network.networks."00-wired" = {
    enable = true;
    matchConfig.Name = "enp*";
    networkConfig.DHCP = "ipv4";
  };
}
