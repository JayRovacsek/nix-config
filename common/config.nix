_: {
  hosts = {
    "alakazam" = rec {
      domains = [ "local" ];
      fqdns = builtins.map (d: "${hostname}.${d}") domains;
      hostname = "alakazam";
      ips = [ "192.168.1.221" ];
    };
    "authelia" = rec {
      domains = [ "local" ];
      fqdns = builtins.map (d: "${hostname}.${d}") domains;
      hostname = "authelia";
      ips = [ "192.168.9.2" ];
    };
    "car_bed" = rec {
      domains = [ "local" ];
      fqdns = builtins.map (d: "${hostname}.${d}") domains;
      hostname = "car_bed";
      ips = [ "192.168.3.10" ];
    };
    "deluge" = rec {
      domains = [ "local" ];
      fqdns = builtins.map (d: "${hostname}.${d}") domains;
      hostname = "deluge";
      ips = [ "192.168.4.130" ];
    };
    "dragonite" = rec {
      domains = [ "local" ];
      fqdns = builtins.map (d: "${hostname}.${d}") domains;
      hostname = "dragonite";
      ips = [ "192.168.1.220" ];
    };
    "duplicati" = rec {
      domains = [ "local" ];
      fqdns = builtins.map (d: "${hostname}.${d}") domains;
      hostname = "duplicati";
      ips = [ "192.168.1.223" ];
    };
    "flare-solverr" = rec {
      domains = [ "local" ];
      fqdns = builtins.map (d: "${hostname}.${d}") domains;
      hostname = "flare-solverr";
      ips = [ "192.168.4.138" ];
    };
    "home-assistant" = rec {
      domains = [ "local" ];
      fqdns = builtins.map (d: "${hostname}.${d}") domains;
      hostname = "home-assistant";
      ips = [ "192.168.12.2" ];
    };
    "igglybuff" = rec {
      domains = [ "local" ];
      fqdns = builtins.map (d: "${hostname}.${d}") domains;
      hostname = "igglybuff";
      ips = [ "192.168.6.8" ];
    };
    "jackett" = rec {
      domains = [ "local" ];
      fqdns = builtins.map (d: "${hostname}.${d}") domains;
      hostname = "jackett";
      ips = [ "192.168.4.129" ];
    };
    "jellyfin" = rec {
      domains = [ "local" ];
      fqdns = builtins.map (d: "${hostname}.${d}") domains;
      hostname = "jellyfin";
      ips = [ "192.168.5.4" ];
    };
    "jigglypuff" = rec {
      domains = [ "local" ];
      fqdns = builtins.map (d: "${hostname}.${d}") domains;
      hostname = "jigglypuff";
      ips = [ "192.168.6.4" ];
    };
    "lidarr" = rec {
      domains = [ "local" ];
      fqdns = builtins.map (d: "${hostname}.${d}") domains;
      hostname = "lidarr";
      ips = [ "192.168.4.133" ];
    };
    "minecraft" = rec {
      domains = [ "local" ];
      fqdns = builtins.map (d: "${hostname}.${d}") domains;
      hostname = "minecraft";
      ips = [ "192.168.17.5" ];
    };
    "nextcloud" = rec {
      domains = [ "local" ];
      fqdns = builtins.map (d: "${hostname}.${d}") domains;
      hostname = "nextcloud";
      ips = [ "192.168.10.2" ];
    };
    "palworld.rovacsek.com" = rec {
      domains = [ "local" ];
      fqdns = builtins.map (d: "${hostname}.${d}") domains;
      hostname = "palworld.rovacsek.com";
      ips = [ "192.168.17.2" ];
    };
    pfsense = rec {
      domains = [
        "local"
        "rovacsek.com"
      ];
      fqdns = builtins.map (d: "${hostname}.${d}") domains;
      hostname = "pfsense";
      ips = [
        "192.168.1.1"
      ];
    };

    "porygon" = rec {
      domains = [ "local" ];
      fqdns = builtins.map (d: "${hostname}.${d}") domains;
      hostname = "porygon";
      ips = [ "192.168.17.2" ];
    };
    "prowlarr" = rec {
      domains = [ "local" ];
      fqdns = builtins.map (d: "${hostname}.${d}") domains;
      hostname = "prowlarr";
      ips = [ "192.168.4.137" ];
    };
    "radarr" = rec {
      domains = [ "local" ];
      fqdns = builtins.map (d: "${hostname}.${d}") domains;
      hostname = "radarr";
      ips = [ "192.168.4.132" ];
    };
    "sonarr" = rec {
      domains = [ "local" ];
      fqdns = builtins.map (d: "${hostname}.${d}") domains;
      hostname = "sonarr";
      ips = [ "192.168.4.131" ];
    };
    "speedtest" = rec {
      domains = [ "local" ];
      fqdns = builtins.map (d: "${hostname}.${d}") domains;
      hostname = "speedtest";
      ips = [ "192.168.1.222" ];
    };
    "stubby" = rec {
      domains = [ "local" ];
      fqdns = builtins.map (d: "${hostname}.${d}") domains;
      hostname = "stubby";
      ips = [ "192.168.6.3" ];
    };
    "swag" = rec {
      domains = [ "local" ];
      fqdns = builtins.map (d: "${hostname}.${d}") domains;
      hostname = "swag";
      ips = [ "192.168.5.3" ];
    };
    "tdarr-node-01" = rec {
      domains = [ "local" ];
      fqdns = builtins.map (d: "${hostname}.${d}") domains;
      hostname = "tdarr-node-01";
      ips = [ "192.168.4.136" ];
    };
    "tdarr" = rec {
      domains = [ "local" ];
      fqdns = builtins.map (d: "${hostname}.${d}") domains;
      hostname = "tdarr";
      ips = [ "192.168.4.135" ];
    };
    "terraria" = rec {
      domains = [ "local" ];
      fqdns = builtins.map (d: "${hostname}.${d}") domains;
      hostname = "terraria";
      ips = [ "192.168.17.4" ];
    };
    "tv" = rec {
      domains = [ "local" ];
      fqdns = builtins.map (d: "${hostname}.${d}") domains;
      hostname = "tv";
      ips = [ "192.168.3.2" ];
    };
    "ubiquiti_ap" = rec {
      domains = [ "local" ];
      fqdns = builtins.map (d: "${hostname}.${d}") domains;
      hostname = "ubiquiti_ap";
      ips = [ "192.168.1.3" ];
    };
    "valheim" = rec {
      domains = [ "local" ];
      fqdns = builtins.map (d: "${hostname}.${d}") domains;
      hostname = "valheim";
      ips = [ "192.168.17.3" ];
    };
    "victreebel" = rec {
      domains = [ "local" ];
      fqdns = builtins.map (d: "${hostname}.${d}") domains;
      hostname = "victreebel";
      ips = [ "192.168.7.12" ];
    };
    "wigglytuff" = rec {
      domains = [ "local" ];
      fqdns = builtins.map (d: "${hostname}.${d}") domains;
      hostname = "wigglytuff";
      ips = [ "192.168.3.4" ];
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
  };
}
