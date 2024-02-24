_: {
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
      nodes = [ "192.168.1.1" "192.168.1.2" ];
      port = 5000;
      protocol = "http";
      subdomain = "binarycache";
    };

    code = {
      authelia = true;
      ipv4 = "192.168.1.220";
      port = 3001;
      protocol = "http";
      subdomain = "code";
    };

    exporters-node = { port = 9100; };

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

    headscale = {
      authelia = false;
      ipv4 = "192.168.25.2";
      port = 8080;
      protocol = "http";
      subdomain = "headscale";

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
      ipv4 = "127.0.0.1";
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
      ipv4 = "127.0.0.1";
      port = 3100;
      protocol = "http";
      push-api = "loki/api/v1/push";
      subdomain = "loki";
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
      ipv4 = "127.0.0.1";
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
  };
}