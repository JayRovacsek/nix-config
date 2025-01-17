_: {
  hosts = {
    alakazam = {
      hostname = "alakazam";
      ips = [
        {
          address = "192.168.1.221";
          fqdn = "alakazam.local";
        }
      ];
    };

    bellsprout = {
      hostname = "bellsprout";
      ips = [
        {
          address = "192.168.4.131";
          fqdn = "bellsprout.local";
        }
        {
          address = "192.168.4.131";
          fqdn = "sonarr.local";
        }
      ];
    };

    car_bed = {
      hostname = "car_bed";
      ips = [
        {
          address = "192.168.3.10";
          fqdn = "car_bed.local";
        }
      ];
    };

    dragonite = {
      hostname = "dragonite";
      ips = [
        {
          address = "192.168.1.220";
          fqdn = "dragonite.local";
        }
        {
          address = "192.168.5.4";
          fqdn = "jellyfin.local";
        }
        {
          address = "192.168.5.4";
          fqdn = "jellyseerr.local";
        }
      ];
    };

    igglybuff = {
      hostname = "igglybuff";
      ips = [
        {
          address = "192.168.6.8";
          fqdn = "igglybuff.local";
        }
      ];
    };

    jigglypuff = {
      hostname = "jigglypuff";
      ips = [
        {
          address = "192.168.6.4";
          fqdn = "jigglypuff.local";
        }
      ];
    };

    machop = {
      hostname = "machop";
      ips = [
        {
          address = "192.168.4.133";
          fqdn = "machop.local";
        }
      ];
    };

    magikarp = {
      hostname = "magikarp";
      ips = [
        {
          address = "192.168.25.2";
          fqdn = "magikarp.local";
        }
      ];
    };

    mankey = {
      hostname = "mankey";
      ips = [
        {
          address = "192.168.4.130";
          fqdn = "mankey.local";
        }
      ];
    };

    meowth = {
      hostname = "meowth";
      ips = [
        {
          address = "192.168.4.137";
          fqdn = "meowth.local";
        }
      ];
    };

    nidoking = {
      hostname = "nidoking";
      ips = [
        {
          address = "192.168.10.3";
          fqdn = "nidoking.local";
        }
        {
          address = "192.168.10.3";
          fqdn = "nextcloud.local";
        }
      ];
    };

    nidorino = {
      hostname = "nidorino";
      ips = [
        {
          address = "192.168.9.2";
          fqdn = "nidorino.local";
        }
        {
          address = "192.168.9.2";
          fqdn = "authelia.local";
        }
      ];
    };

    oddish = {
      hostname = "oddish";
      ips = [
        {
          address = "192.168.4.139";
          fqdn = "oddish.local";
        }
        {
          address = "192.168.4.139";
          fqdn = "bazarr.local";
        }
      ];
    };

    pfsense = {
      hostname = "pfsense";
      ips = [
        {
          address = "192.168.1.1";
          fqdn = "pfsense.local";
        }
      ];
    };

    poliwag = {
      hostname = "poliwag";
      ips = [
        {
          address = "192.168.4.132";
          fqdn = "poliwag.local";
        }
        {
          address = "192.168.4.132";
          fqdn = "radarr.local";
        }
      ];
    };

    porygon = {
      hostname = "porygon";
      ips = [
        {
          address = "192.168.17.2";
          fqdn = "porygon.local";
        }
        {
          address = "192.168.17.2";
          fqdn = "minecraft.local";
        }
        {
          address = "192.168.17.2";
          fqdn = "geo.hivebedrock.network";
        }
        {
          address = "192.168.17.2";
          fqdn = "hivebedrock.network";
        }
        {
          address = "192.168.17.2";
          fqdn = "play.inpvp.net";
        }
        {
          address = "192.168.17.2";
          fqdn = "mco.lbsg.net";
        }
        {
          address = "192.168.17.2";
          fqdn = "play.galaxite.net";
        }
        {
          address = "192.168.17.2";
          fqdn = "play.enchanted.gg";
        }
        {
          address = "192.168.17.2";
          fqdn = "palworld.local";
        }
        {
          address = "192.168.17.2";
          fqdn = "terraria.local";
        }
        {
          address = "192.168.17.2";
          fqdn = "valheim.local";
        }
      ];
    };

    slowpoke = {
      hostname = "slowpoke";
      ips = [
        {
          address = "192.168.4.138";
          fqdn = "slowpoke.local";
        }
      ];
    };

    tv = {
      hostname = "tv";
      ips = [
        {
          address = "192.168.3.2";
          fqdn = "tv.local";
        }
      ];
    };

    ubiquiti_ap = {
      hostname = "ubiquiti_ap";
      ips = [
        {
          address = "192.168.1.3";
          fqdn = "ubiquiti_ap.local";
        }
      ];
    };

    victreebel = {
      hostname = "victreebel";
      ips = [
        {
          address = "192.168.7.12";
          fqdn = "victreebel.local";
        }
      ];
    };

    wigglytuff = {
      hostname = "wigglytuff";
      ips = [
        {
          address = "192.168.3.4";
          fqdn = "wigglytuff.local";
        }
      ];
    };
  };

  networks = [
    {
      name = "iot";
      vlan-tag = 3;
    }
    {
      name = "download";
      vlan-tag = 4;
    }
    {
      name = "reverse-proxy";
      vlan-tag = 5;
    }
    {
      name = "dns";
      vlan-tag = 6;
    }
    {
      name = "wlan";
      vlan-tag = 8;
    }
    {
      name = "auth";
      vlan-tag = 9;
    }
    {
      name = "nextcloud";
      vlan-tag = 10;
    }
    {
      name = "game";
      vlan-tag = 17;
    }
    {
      name = "log";
      vlan-tag = 18;
    }
    {
      name = "headscale";
      vlan-tag = 25;
    }
  ];

  services = {
    authelia = {
      authelia = false;
      ipv4 = "192.168.9.2";
      port = 9091;
      protocol = "http";
      subdomain = "authelia";
    };

    bedrock-connect = {
      ipv4 = "192.168.17.2";
      port = 19134;
    };

    binarycache = {
      authelia = false;
      ipv4 = "192.168.1.220";
      port = 5000;
      protocol = "http";
      subdomain = "binarycache";
    };

    blocky = {
      authelia = false;
      ipv4 = null;
      nodes = [
        "192.168.1.220"
        "192.168.6.4"
        "192.168.6.8"
      ];
      port = 53;
      protocol = "dns";
      subdomain = null;
    };

    code = {
      authelia = true;
      ipv4 = "192.168.1.220";
      port = 3001;
      protocol = "http";
      subdomain = "code";
    };

    exporters-node.port = 9100;

    deluge = {
      authelia = true;
      ipv4 = "192.168.4.130";
      port = 8112;
      protocol = "http";
      subdomain = "deluge";
    };

    firefox-syncserver = {
      authelia = false;
      ipv4 = "192.168.1.220";
      port = 5002;
      protocol = "http";
      subdomain = "firefox-syncserver";
    };

    flaresolverr = {
      authelia = false;
      ipv4 = "192.168.4.138";
      port = 8191;
      protocol = "http";
      subdomain = "flaresolverr";
    };

    harmonia = {
      authelia = false;
      ipv4 = "192.168.1.220";
      port = 5001;
      protocol = "http";
      subdomain = "binarycache";
    };

    headscale = {
      authelia = false;
      ipv4 = "192.168.25.2";
      port = 8080;
      protocol = "http";
      subdomain = "headscale";
      base_domain = "rovacsek.com.internal";

      derpServerStunPort = 3478;
      grpcPort = 50443;
      metricsPort = 9090;
    };

    hydra = {
      authelia = false;
      ipv4 = "192.168.1.220";
      port = 3000;
      badge-port = 8081;
      protocol = "http";
      subdomain = "hydra";
    };

    grafana = {
      authelia = true;
      ipv4 = "192.168.18.2";
      port = 3002;
      protocol = "http";
      subdomain = "grafana";
    };

    jellyfin = {
      authelia = false;
      ipv4 = "192.168.1.220";
      port = 8096;
      protocol = "http";
      subdomain = "jellyfin";

      https-port = 8920;

      groups.jellyfin = {
        gid = 10001;
        members = [ "jellyfin" ];
      };

      users.jellyfin = {
        createHome = false;
        description = "User account generated for running a specific service";
        group = "jellyfin";
        isSystemUser = true;
        uid = 998;
      };
    };

    jellyseerr = {
      authelia = false;
      ipv4 = "192.168.1.220";
      port = 5055;
      protocol = "http";
      subdomain = "jellyseerr";
    };

    lidarr = {
      authelia = true;
      ipv4 = "192.168.4.133";
      port = 8686;
      protocol = "http";
      subdomain = "lidarr";
    };

    loki = {
      authelia = false;
      ipv4 = "192.168.18.2";
      port = 3100;
      protocol = "http";
      push-api = "loki/api/v1/push";
      subdomain = "loki";
      user = {
        gid = 401;
        uid = 401;
      };
    };

    media = {
      groups.media = {
        gid = 400;
        members = [
          "jellyfin"
        ];
      };
      users.media = {
        group = "media";
        isSystemUser = true;
        uid = 400;
      };
    };

    minecraft = {
      ipv4 = "192.168.17.2";
      bedrock-port = 19133;
      java-port = 25565;
      subdomain = "minecraft";
    };

    nextcloud = {
      authelia = false;
      ipv4 = "192.168.10.3";
      port = 443;
      protocol = "https";
      subdomain = "nextcloud";
    };

    nginx = {
      authelia = false;
      ipv4 = "192.168.5.3";
    };

    openvpn = {
      port = 1194;
      protocol = "udp";
    };

    openssh = {
      public-keys = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIMO6FTToBOIByP9uVP2Ke2jGD/ESxPcXEMhvR7unukNGAAAABHNzaDo= jay@rovacsek.com"
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAINNGQz3ekO1q/DrxuhP7Ck3TnP9V4ooF5vo8ibFWKKqFAAAABHNzaDo= jay@rovacsek.com"
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDuG5e8MReihLwtKk3/rbXcZKNfiapcqAhWu//fC0aMKAAAABHNzaDo= jay@rovacsek.com"
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAILDjbVDfVzpcxnx9fl4pBr6eKAJdSyX4JLyBK02N9YeFAAAABHNzaDo= jay@rovacsek.com"
      ];
    };

    palworld = {
      authelia = false;
      ipv4 = "192.168.17.2";
      port = 8211;
      subdomain = "palworld";
    };

    pfsense = {
      authelia = true;
      ipv4 = "192.168.5.1";
      port = 443;
      protocol = "https";
      subdomain = "pfsense";
    };

    prometheus = {
      authelia = false;
      ipv4 = "192.168.18.2";
      port = 9092;
      protocol = "http";
      write-api = "api/v1/write";
      subdomain = "prometheus";
    };

    prowlarr = {
      authelia = true;
      ipv4 = "192.168.4.137";
      port = 9696;
      protocol = "http";
      subdomain = "prowlarr";
    };

    radarr = {
      authelia = true;
      ipv4 = "192.168.4.132";
      port = 7878;
      protocol = "http";
      subdomain = "radarr";
    };

    sonarr = {
      authelia = true;
      ipv4 = "192.168.4.131";
      port = 9999;
      protocol = "http";
      subdomain = "sonarr";
    };

    telegraf.output.prometheus.port = 9273;

    unifi = {
      authelia = true;
      ipv4 = "192.168.1.220";
      port = 8443;
      protocol = "https";
      subdomain = "unifi";
    };

    valheim = {
      authelia = false;
      ipv4 = "192.168.17.2";
      ports = [
        2456
        2457
      ];
      protocol = "udp";
      subdomain = "valheim";

      groups.valheim = {
        gid = 10105;
        members = [ "valheim" ];
      };

      users.valheim = {
        group = "valheim";
        isSystemUser = true;
        uid = 10105;
      };
    };
  };
}
