{ config, lib, ... }:
let
  # The below variables are inherited by both wired and wireless
  # configs.
  networkConfig = {
    # Only configure DHCP via ipv4 
    DHCP = "ipv4";
    # Include the configured localDomain if one exists
    Domains = [ config.networking.localDomain ];
  };
  dns = [ "127.0.0.1" ];

in
{
  # Ensure the networking options as well as blocky module is
  # included to localise DNS for end-to-end encrypted DNS.
  imports = [
    ../blocky
    ../../options/modules/networking
    ../../options/modules/systemd
  ];

  networking = {
    dhcpcd.enable = false;
    networkmanager.enable = false;
    useNetworkd = true;
  };

  services.resolved.enable = false;

  systemd = {
    services.systemd-networkd-wait-online.enable = lib.mkForce false;

    network.networks = {
      "10-wired" = {
        inherit dns networkConfig;

        matchConfig.Name = "en*";

        # The kernel's route metric (same as configured with ip) decides which route to use for outgoing packets, in cases when several match. This will be the case when both wireless and wired devices on the system have active connections. To break the tie, the kernel uses the metric. If one of the connections is terminated, the other automatically wins without there being a gap with nothing configured (ongoing transfers may still not deal with this nicely but that is at a different OSI layer). 
        # Above as per: https://wiki.archlinux.org/title/Systemd-networkd
        # TLDR: prefer wired connections
        dhcpV4Config.RouteMetric = 10;
      };

      "20-wireless" = {
        inherit dns networkConfig;

        matchConfig.Name = "wl*";

        # The kernel's route metric (same as configured with ip) decides which route to use for outgoing packets, in cases when several match. This will be the case when both wireless and wired devices on the system have active connections. To break the tie, the kernel uses the metric. If one of the connections is terminated, the other automatically wins without there being a gap with nothing configured (ongoing transfers may still not deal with this nicely but that is at a different OSI layer). 
        # Above as per: https://wiki.archlinux.org/title/Systemd-networkd
        # TLDR: prefer wired connections
        dhcpV4Config.RouteMetric = 20;
      };
    };
  };
}
