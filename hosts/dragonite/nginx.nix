{ config, ... }:
let
  inherit (config.flake.lib) merge;
  inherit (config.flake.lib.nginx) generate-vhosts;

  deluge-vhost = generate-vhosts {
    inherit config;
    service-name = "deluge";
    overrides.locations."/".proxyPass = "http://192.168.4.130:8112";
  };

  headscale-vhost = generate-vhosts {
    inherit config;
    service-name = "headscale";
    overrides.locations."/" = {
      extraConfig = "";
      proxyPass = "http://192.168.25.2:8080";
      proxyWebsockets = true;
    };
  };

  lidarr-vhost = generate-vhosts {
    inherit config;
    service-name = "lidarr";
    overrides.locations = {
      "/".proxyPass = "http://192.168.4.133:8686";
      "~ (/lidarr)?/api" = {
        extraConfig = "";
        proxyPass = "http://192.168.4.133:8686";
      };
    };
  };

  nextcloud-vhost = generate-vhosts {
    inherit config;
    service-name = "nextcloud";
    overrides = {
      # The below is required as by default nginx will utilise differing
      # max client body sizes - this is simply a copy of the recommended
      # nextcloud proxy config, minus any headers as the response from
      # the second nginx proxy will add these headers
      #
      # Why do we need a dual reverse proxy config, to avoid needing to rewrite large
      # elements of the upstream opinions on nextcloud.
      extraConfig = ''
        index index.php index.html /index.php$request_uri;

        client_max_body_size 10G;
        fastcgi_buffers 64 4K;
        fastcgi_hide_header X-Powered-By;
        gzip on;
        gzip_vary on;
        gzip_comp_level 4;
        gzip_min_length 256;
        gzip_proxied expired no-cache no-store private no_last_modified no_etag auth;
        gzip_types application/atom+xml application/javascript application/json application/ld+json application/manifest+json application/rss+xml application/vnd.geo+json application/vnd.ms-fontobject application/x-font-ttf application/x-web-app-manifest+json application/xhtml+xml application/xml font/opentype image/bmp image/svg+xml image/x-icon text/cache-manifest text/css text/plain text/vcard text/vnd.rim.location.xloc text/vtt text/x-component text/x-cross-domain-policy;
      '';
      locations."/" = {
        extraConfig = "";
        proxyPass = "http://192.168.10.3";
      };
    };
  };

  pfsense-vhost = generate-vhosts {
    inherit config;
    service-name = "pfsense";
    overrides.locations."/".proxyPass = "https://192.168.1.1:443";
  };

  portainer-vhost = generate-vhosts {
    inherit config;
    service-name = "portainer";
    overrides.locations."/".proxyPass = "http://192.168.1.220:9000";
  };

  prowlarr-vhost = generate-vhosts {
    inherit config;
    service-name = "prowlarr";
    overrides.locations = {
      "/" = { proxyPass = "http://192.168.4.137:9696"; };
      "~ (/prowlarr)?(/[0-9]+)?/api" = {
        extraConfig = "";
        proxyPass = "http://192.168.4.137:9696";
      };
      "~ (/prowlarr)?(/[0-9]+)?/download" = {
        extraConfig = "";
        proxyPass = "http://192.168.4.137:9696";
      };
    };
  };

  radarr-vhost = generate-vhosts {
    inherit config;
    service-name = "radarr";
    overrides.locations = {
      "/".proxyPass = "http://192.168.4.132:7878";
      "~ (/radarr)?/api" = {
        extraConfig = "";
        proxyPass = "http://192.168.4.132:7878";
      };
    };
  };

  sonarr-vhost = generate-vhosts {
    inherit config;
    service-name = "sonarr";
    overrides.locations = {
      "/".proxyPass = "http://192.168.4.131:9999";
      "~ (/sonarr)?/api" = {
        extraConfig = "";
        proxyPass = "http://192.168.4.131:9999";
      };
    };
  };
in {
  services.nginx.virtualHosts = merge [
    deluge-vhost
    headscale-vhost
    lidarr-vhost
    nextcloud-vhost
    pfsense-vhost
    portainer-vhost
    prowlarr-vhost
    radarr-vhost
    sonarr-vhost
  ];
}
