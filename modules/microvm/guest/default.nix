{ config, ... }:
let inherit (config.networking) hostName;
in {
  networking.useNetworkd = true;

  microvm.shares = [{
    # On the host
    source = "/var/lib/microvms/${hostName}/journal";
    # In the MicroVM
    mountPoint = "/var/log/journal";
    tag = "journal";
    proto = "virtiofs";
    socket = "journal.sock";
  }];

  nix.settings = {
    substituters = [ "https://microvm.cachix.org/" ];
    trusted-public-keys =
      [ "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys=" ];
  };

  systemd.network.networks."00-wired" = {
    enable = true;
    matchConfig.Name = "enp*";
    networkConfig.DHCP = "yes";
  };
}
