{ lib, ... }: {
  # Use blocky over resolved so we can leverage dns filter lists
  # and local host definitions
  imports = [ ../../blocky ];
  services.resolved.enable = false;

  networking = {
    useNetworkd = true;
    dhcpcd.enable = false;
    networkmanager.enable = false;
    nat = {
      enable = true;
      enableIPv6 = true;
      # Change this to the interface with upstream Internet access
      externalInterface = "enp0s31f6";
      internalInterfaces = [ "microvm" ];
    };
  };

  systemd = {
    services.systemd-networkd-wait-online.enable = lib.mkForce false;
    network = {
      enable = true;
      networks = {
        "00-wired" = {
          matchConfig.Name = "en*";
          networkConfig = {
            DHCP = "ipv4";
            Domains = [ "lan" ];
          };

          dns = [ "127.0.0.1" ];

          # The kernel's route metric (same as configured with ip) decides which route to use for outgoing packets, in cases when several match. This will be the case when both wireless and wired devices on the system have active connections. To break the tie, the kernel uses the metric. If one of the connections is terminated, the other automatically wins without there being a gap with nothing configured (ongoing transfers may still not deal with this nicely but that is at a different OSI layer). 
          # Above as per: https://wiki.archlinux.org/title/Systemd-networkd
          # TLDR: prefer wired connections
          dhcpV4Config.RouteMetric = 10;
        };

        "00-wireless" = {
          matchConfig.Name = "wl*";
          # The kernel's route metric (same as configured with ip) decides which route to use for outgoing packets, in cases when several match. This will be the case when both wireless and wired devices on the system have active connections. To break the tie, the kernel uses the metric. If one of the connections is terminated, the other automatically wins without there being a gap with nothing configured (ongoing transfers may still not deal with this nicely but that is at a different OSI layer). 
          # Above as per: https://wiki.archlinux.org/title/Systemd-networkd
          # TLDR: prefer wired connections
          dhcpV4Config.RouteMetric = 20;
          networkConfig = {
            DHCP = "ipv4";
            Domains = [ "lan" ];
          };

          dns = [ "127.0.0.1" ];
        };

        "10-microvm" = {
          matchConfig.Name = "microvm";
          networkConfig = {
            DHCPServer = true;
            IPv6SendRA = true;
          };
          addresses = [
            { addressConfig.Address = "10.0.0.1/24"; }
            { addressConfig.Address = "fd12:3456:789a::1/64"; }
          ];
          ipv6Prefixes = [{ ipv6PrefixConfig.Prefix = "fd12:3456:789a::/64"; }];
        };
        "11-microvm" = {
          matchConfig.Name = "vm-*";
          # Attach to the bridge that was configured above
          networkConfig.Bridge = "microvm";
        };
      };
      netdevs."10-microvm".netdevConfig = {
        Kind = "bridge";
        Name = "microvm";
      };
    };
  };
}
