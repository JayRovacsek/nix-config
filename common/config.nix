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
      shares = [ ];
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
      macAddress = "02:42:c0:a8:04:83";
      shares = [
        {
          hostPath = "/srv/tv";
          isReadOnly = false;
          mountPoint = "/srv/tv";
          name = "tv";
        }
        {
          hostPath = "/srv/downloads";
          isReadOnly = false;
          mountPoint = "/srv/downloads";
          name = "downloads";
        }
      ];
      vlan = "download";
    };
    car_bed = {
      hostname = "car_bed";
      ips = [
        {
          address = "192.168.3.10";
          fqdn = "car_bed.local";
        }
      ];
      shares = [ ];
    };
    clefairy = {
      hostname = "clefairy";
      ips = [
        {
          address = "192.168.1.225";
          fqdn = "clefairy.local";
        }
      ];
      isDnsServer = false;
      macAddress = "02:42:c0:a8:01:e1";
      shares = [ ];
      vlan = null;
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
      isDnsServer = true;
      shares = [ ];
    };
    igglybuff = {
      hostname = "igglybuff";
      ips = [
        {
          address = "192.168.6.8";
          fqdn = "igglybuff.local";
        }
      ];
      isDnsServer = true;
      macAddress = "02:42:c0:a8:06:08";
      shares = [ ];
      vlan = "dns";
    };
    ivysaur = {
      hostname = "ivysaur";
      ips = [
        {
          address = "192.168.1.5";
          fqdn = "ivysaur.local";
        }
      ];
      isDnsServer = true;
      shares = [ ];
    };
    jigglypuff = {
      hostname = "jigglypuff";
      ips = [
        {
          address = "192.168.6.4";
          fqdn = "jigglypuff.local";
        }
      ];
      shares = [ ];
    };
    machop = {
      hostname = "machop";
      ips = [
        {
          address = "192.168.4.133";
          fqdn = "machop.local";
        }
      ];
      macAddress = "02:42:c0:a8:04:85";
      shares = [
        {
          hostPath = "/srv/music";
          isReadOnly = false;
          mountPoint = "/srv/music";
          name = "music";
        }
        {
          hostPath = "/srv/downloads";
          isReadOnly = false;
          mountPoint = "/srv/downloads";
          name = "downloads";
        }
      ];
      vlan = "download";
    };
    magikarp = {
      hostname = "magikarp";
      ips = [
        {
          address = "192.168.25.2";
          fqdn = "magikarp.local";
        }
      ];
      macAddress = "02:42:c0:a8:19:02";
      shares = [ ];
      vlan = "headscale";
    };
    magnemite = {
      hostname = "magnemite";
      ips = [
        {
          address = "192.168.5.5";
          fqdn = "magnemite.local";
        }
      ];
      shares = [ ];
    };
    magneton = {
      hostname = "magneton";
      ips = [
        {
          address = "192.168.5.6";
          fqdn = "magneton.local";
        }
      ];
      shares = [ ];
    };
    mankey = {
      hostname = "mankey";
      ips = [
        {
          address = "192.168.4.130";
          fqdn = "mankey.local";
        }
      ];
      macAddress = "02:42:c0:a8:04:82";
      shares = [
        {
          hostPath = "/srv/downloads";
          isReadOnly = false;
          mountPoint = "/srv/downloads";
          name = "downloads";
        }
      ];
      vlan = "download";
    };
    meowth = {
      hostname = "meowth";
      ips = [
        {
          address = "192.168.4.137";
          fqdn = "meowth.local";
        }
      ];
      macAddress = "02:42:c0:a8:04:89";
      shares = [ ];
      vlan = "download";
    };
    mr-mime = {
      hostname = "mr-mime";
      ips = [
        {
          address = "192.168.18.2";
          fqdn = "mr-mime.local";
        }
      ];
      macAddress = "02:42:c0:a8:12:02";
      shares = [ ];
      vlan = "log";
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
      shares = [ ];
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
      macAddress = "02:42:c0:a8:09:02";
      shares = [ ];
      vlan = "auth";
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
      shares = [ ];
    };
    onix = {
      hostname = "onix";
      ips = [
        {
          address = "192.168.5.4";
          fqdn = "onix.local";
        }
      ];
      shares = [ ];
    };
    pfsense = {
      hostname = "pfsense";
      ips = [
        {
          address = "192.168.1.1";
          fqdn = "pfsense.local";
        }
      ];
      shares = [ ];
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
      macAddress = "02:42:c0:a8:04:84";
      shares = [
        {
          hostPath = "/srv/movies";
          isReadOnly = false;
          mountPoint = "/srv/movies";
          name = "movies";
        }
        {
          hostPath = "/srv/downloads";
          isReadOnly = false;
          mountPoint = "/srv/downloads";
          name = "downloads";
        }
      ];
      vlan = "download";
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
      shares = [ ];
    };
    slowpoke = {
      hostname = "slowpoke";
      ips = [
        {
          address = "192.168.4.138";
          fqdn = "slowpoke.local";
        }
      ];
      macAddress = "02:42:c0:a8:04:8a";
      shares = [ ];
      vlan = "download";
    };
    tentacruel = {
      hostname = "tentacruel";
      ips = [
        {
          address = "192.168.12.2";
          fqdn = "tentacruel.local";
        }
        {
          address = "192.168.12.2";
          fqdn = "home-assistant.local";
        }
      ];
      shares = [ ];
    };
    tv = {
      hostname = "tv";
      ips = [
        {
          address = "192.168.3.2";
          fqdn = "tv.local";
        }
      ];
      shares = [ ];
    };
    ubiquiti_ap = {
      hostname = "ubiquiti_ap";
      ips = [
        {
          address = "192.168.1.3";
          fqdn = "ubiquiti_ap.local";
        }
      ];
      shares = [ ];
    };
    victreebel = {
      hostname = "victreebel";
      ips = [
        {
          address = "192.168.7.12";
          fqdn = "victreebel.local";
        }
      ];
      shares = [ ];
    };
    vileplume = {
      hostname = "vileplume";
      ips = [
        {
          address = "192.168.7.15";
          fqdn = "vileplume.local";
        }
      ];
      shares = [ ];
    };
    wartortle = {
      hostname = "wartortle";
      ips = [
        {
          address = "192.168.1.6";
          fqdn = "wartortle.local";
        }
      ];
      isDnsServer = true;
      shares = [ ];
    };
    wigglytuff = {
      hostname = "wigglytuff";
      ips = [
        {
          address = "192.168.3.4";
          fqdn = "wigglytuff.local";
        }
      ];
      shares = [ ];
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
      name = "r-proxy";
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
      name = "home-assistant";
      vlan-tag = 12;
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
    anubis = {
      bind-network = "tcp";
      ipv4 = "192.168.1.220";
      metrics-bind-network = "tcp";
      metrics-port = 4445;
      port = 4444;
      protocol = "http";
    };
    authelia = {
      authelia = false;
      ipv4 = "192.168.9.2";
      port = 9091;
      protocol = "http";
      subdomain = "authelia";
    };
    bazarr = {
      authelia = true;
      ipv4 = "192.168.4.139";
      port = 6767;
      protocol = "http";
      subdomain = "bazarr";
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
    buildbot = {
      authelia = false;
      ipv4 = "192.168.5.5";
      pbPort = 9989;
      pbProtocol = "tcp";
      port = 8010;
      protocol = "http";
      subdomain = "buildbot";
    };
    code = {
      authelia = true;
      ipv4 = "192.168.1.220";
      port = 3001;
      protocol = "http";
      subdomain = "code";
    };
    deluge = {
      authelia = true;
      ipv4 = "192.168.4.130";
      port = 8112;
      protocol = "http";
      subdomain = "deluge";
    };
    exporters-node = {
      port = 9100;
    };
    firefox-syncserver = {
      authelia = false;
      ipv4 = "127.0.0.1";
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
    grafana = {
      authelia = true;
      ipv4 = "192.168.1.220";
      port = 3002;
      protocol = "http";
      subdomain = "grafana";
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
      base_domain = "rovacsek.com.internal";
      derpServerStunPort = 3478;
      grpcPort = 50443;
      ipv4 = "192.168.25.2";
      metricsPort = 9090;
      port = 8080;
      protocol = "http";
      subdomain = "headscale";
    };
    home-assistant = {
      authelia = true;
      ipv4 = "192.168.12.2";
      port = 8123;
      protocol = "http";
      subdomain = "home-assistant";
    };
    hydra = {
      authelia = false;
      badge-port = 8081;
      ipv4 = "192.168.1.220";
      port = 3000;
      protocol = "http";
      subdomain = "hydra";
    };
    jellyfin = {
      authelia = false;
      groups = {
        jellyfin = {
          gid = 10001;
          members = [ "jellyfin" ];
        };
      };
      https-port = 8920;
      ipv4 = "192.168.1.220";
      port = 8096;
      protocol = "http";
      subdomain = "jellyfin";
      users = {
        jellyfin = {
          createHome = false;
          description = "User account generated for running a specific service";
          group = "jellyfin";
          isSystemUser = true;
          uid = 998;
        };
      };
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
      ipv4 = "192.168.1.220";
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
      groups = {
        media = {
          gid = 400;
          members = [ "jellyfin" ];
        };
      };
      users = {
        media = {
          group = "media";
          isSystemUser = true;
          uid = 400;
        };
      };
    };
    minecraft = {
      bedrock-port = 19133;
      ipv4 = "192.168.17.2";
      java-port = 25565;
      subdomain = "minecraft";
    };
    nextcloud = {
      authelia = false;
      hostName = "nextcloud.rovacsek.com";
      ipv4 = "192.168.1.220";
      port = 443;
      protocol = "https";
      subdomain = "nextcloud";
    };
    nginx = {
      authelia = false;
      ipv4 = "192.168.1.220";
    };
    openssh = {
      public-keys = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIMO6FTToBOIByP9uVP2Ke2jGD/ESxPcXEMhvR7unukNGAAAABHNzaDo= jay@rovacsek.com"
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAINNGQz3ekO1q/DrxuhP7Ck3TnP9V4ooF5vo8ibFWKKqFAAAABHNzaDo= jay@rovacsek.com"
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDuG5e8MReihLwtKk3/rbXcZKNfiapcqAhWu//fC0aMKAAAABHNzaDo= jay@rovacsek.com"
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAILDjbVDfVzpcxnx9fl4pBr6eKAJdSyX4JLyBK02N9YeFAAAABHNzaDo= jay@rovacsek.com"
      ];
    };
    openvpn = {
      port = 1194;
      protocol = "udp";
    };
    palworld = {
      authelia = false;
      ipv4 = "192.168.17.2";
      port = 8211;
      subdomain = "palworld";
    };
    pfsense = {
      authelia = true;
      ipv4 = "192.168.1.1";
      port = 443;
      protocol = "https";
      subdomain = "pfsense";
    };
    prometheus = {
      authelia = false;
      ipv4 = "192.168.1.220";
      port = 9092;
      protocol = "http";
      subdomain = "prometheus";
      write-api = "api/v1/write";
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
    seerr = {
      authelia = false;
      ipv4 = "192.168.1.220";
      port = 5055;
      protocol = "http";
      subdomain = "jellyseerr";
    };
    sonarr = {
      authelia = true;
      ipv4 = "192.168.4.131";
      port = 9999;
      protocol = "http";
      subdomain = "sonarr";
    };
    telegraf = {
      output = {
        prometheus = {
          port = 9273;
        };
      };
    };
    unifi = {
      authelia = true;
      ipv4 = "192.168.1.220";
      port = 8443;
      protocol = "https";
      subdomain = "unifi";
    };
    valheim = {
      authelia = false;
      groups = {
        valheim = {
          gid = 10105;
          members = [ "valheim" ];
        };
      };
      ipv4 = "192.168.17.2";
      ports = [
        2456
        2457
      ];
      protocol = "udp";
      subdomain = "valheim";
      users = {
        valheim = {
          group = "valheim";
          isSystemUser = true;
          uid = 10105;
        };
      };
    };
  };
}
