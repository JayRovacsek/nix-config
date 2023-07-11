{ config, lib, ... }: {
  networking = {
    hostName = "jigglypuff";
    hostId = "d2a7f613";
    # We're only got a single interface on the pi, so it'll be fine
    # for now to just assume eth0
    usePredictableInterfaceNames = false;
  };

  systemd.network = {
    netdevs."00-vlan-dns" = {
      enable = true;
      netdevConfig = {
        Kind = "vlan";
        Name = "vlan-dns";
      };
      vlanConfig.Id = 6;
    };

    networks = {
      "00-wired" = {
        enable = true;
        # mkForce is utilised here to override the default systemd
        # settings in the systemd-networkd module
        matchConfig.Name = lib.mkForce "eth0";
        networkConfig = lib.mkForce {
          VLAN = config.systemd.network.netdevs."00-vlan-dns".netdevConfig.Name;
        };
        dhcpV4Config = lib.mkForce { };
      };

      "10-vlan-dns" = {
        enable = true;
        name = config.systemd.network.netdevs."00-vlan-dns".netdevConfig.Name;
        networkConfig.DHCP = "ipv4";
      };
    };
  };
}
