{ config, lib, ... }: {
  systemd.network.netdevs."00-vlan-dns" = {
    enable = true;
    netdevConfig = {
      Kind = "vlan";
      Name = "vlan-dns";
    };
    vlanConfig.Id = 6;
  };

  systemd.network.networks = {
    "00-wired" = {
      networkConfig = lib.mkForce {
        VLAN = config.systemd.network.netdevs."00-vlan-dns".netdevConfig.Name;
      };
      dhcpV4Config = lib.mkForce { };
    };

    "10-vlan-dns" = {
      name = config.systemd.network.netdevs."00-vlan-dns".netdevConfig.Name;
      networkConfig = {
        DHCP = "ipv4";
        Domains = [ "lan" ];
      };
    };
  };
}
