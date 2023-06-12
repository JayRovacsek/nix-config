{ config, ... }: {
  systemd.network.enable = true;

  systemd.network.netdevs."00-vlan-dns" = {
    enable = true;
    netdevConfig = {
      Kind = "vlan";
      Name = "vlan-dns";
    };
    vlanConfig.Id = 6;
  };

  systemd.network.networks = {
    "10-wired" = {
      matchConfig.Name = "en*";
      vlan = [ config.systemd.network.netdevs."00-vlan-dns".netdevConfig.Name ];
    };

    "20-vlan-dns" = {
      matchConfig.Name =
        config.systemd.network.netdevs."00-vlan-dns".netdevConfig.Name;
      networkConfig = {
        DHCP = "ipv4";
        Domains = [ "lan" ];
      };
    };
  };
}
