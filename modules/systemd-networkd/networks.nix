{ config, pkgs, ... }:
let meta = import ./meta.nix { inherit config; };
in {
  systemd.network.networks = {
    "00-wired" = {
      matchConfig.Name = "phys0";
      networkConfig = {
        DHCP = "ipv4";
        Domains = [ "lan" ];
        LinkLocalAddressing = "no";
        # VLAN = if meta.isMicrovmHost then meta.vlans else [ ];
        # MACVLAN = if meta.isMicrovmHost then meta.macvlans else [ ];
      };
      # macvlan = if meta.isMicrovmHost then macvlans else [ ];

      # The kernel's route metric (same as configured with ip) decides which route to use for outgoing packets, in cases when several match. This will be the case when both wireless and wired devices on the system have active connections. To break the tie, the kernel uses the metric. If one of the connections is terminated, the other automatically wins without there being a gap with nothing configured (ongoing transfers may still not deal with this nicely but that is at a different OSI layer). 
      # Above as per: https://wiki.archlinux.org/title/Systemd-networkd
      # TLDR: prefer wired connections
      dhcpV4Config.RouteMetric = 10;
    };

    "10-virt-dns" = {
      enable = meta.isMicrovmHost;
      matchConfig.Name = "br-dns";
      networkConfig.DHCPServer = true;
      addresses = [{ addressConfig.Address = "10.0.0.1/24"; }];
    };

    "10-mvl-dns" = {
      matchConfig.Name = "mvl-dns";
      enable = meta.isMicrovmHost;
      networkConfig = {
        IPForward = "yes";
        DHCP = "ipv4";
        # VLAN = if meta.isMicrovmHost then meta.vlans else [ ];
        MACVLAN = if meta.isMicrovmHost then meta.macvlans else [ ];
      };
    };

    "11-dns" = {
      enable = meta.isMicrovmHost;
      matchConfig.Name = "vm-dns-*";
      networkConfig.Bridge = "mvl-dns";
    };

    "10-wireless" = {
      matchConfig.Name = "wl*";
      networkConfig.DHCP = "yes";
      # The kernel's route metric (same as configured with ip) decides which route to use for outgoing packets, in cases when several match. This will be the case when both wireless and wired devices on the system have active connections. To break the tie, the kernel uses the metric. If one of the connections is terminated, the other automatically wins without there being a gap with nothing configured (ongoing transfers may still not deal with this nicely but that is at a different OSI layer). 
      # Above as per: https://wiki.archlinux.org/title/Systemd-networkd
      # TLDR: prefer wired connections
      dhcpV4Config.RouteMetric = 20;
    };
  };
}
