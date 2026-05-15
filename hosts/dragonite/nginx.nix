{
  config,
  lib,
  self,
  ...
}:
let
  inherit (self.lib) merge;
  inherit (self.lib.nginx) generate-vhosts;
  inherit (self.common.config.services)
    authelia
    firefox-syncserver
    harmonia
    jellyfin
    seerr
    nextcloud
    ;

  authelia-vhost = generate-vhosts {
    inherit config;
    inherit (authelia) subdomain;
    overrides = {
      default = true;
      locations =
        let
          proxyPass = "${authelia.protocol}://${authelia.ipv4}:${builtins.toString authelia.port}";
        in
        {
          "/" = {
            inherit proxyPass;
          };
          "/api/verify" = {
            inherit proxyPass;
          };
        };
    };
  };

  firefox-syncserver-vhost = generate-vhosts {
    inherit config;
    inherit (firefox-syncserver) subdomain;
    overrides = {
      enableAuthelia = false;
      locations."/".proxyPass =
        "${firefox-syncserver.protocol}://${firefox-syncserver.ipv4}:${builtins.toString firefox-syncserver.port}";
    };
  };

  harmonia-vhost = generate-vhosts {
    inherit config;
    inherit (harmonia) subdomain;
    overrides = {
      enableAuthelia = false;
      locations."/" = {
        # Ref; https://github.com/nix-community/harmonia/?tab=readme-ov-file#configuration-for-public-binary-cache-on-nixos
        extraConfig = ''
          proxy_connect_timeout 300;
          proxy_set_header Host $host;
          proxy_redirect http:// https://;
          proxy_http_version 1.1;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection $connection_upgrade;

          allow 10.0.0.0/8;
          allow 172.16.0.0/12;
          allow 192.168.0.0/16;
          deny all;
        '';
        proxyPass = "${harmonia.protocol}://${harmonia.ipv4}:${builtins.toString harmonia.port}";
      };
    };
  };

  jellyfin-vhost = generate-vhosts {
    inherit config;
    inherit (jellyfin) subdomain;
    overrides = {
      enableAuthelia = false;
      locations =
        let
          proxyPass = "${jellyfin.protocol}://${jellyfin.ipv4}:${builtins.toString jellyfin.port}";
        in
        {
          "/" = {
            extraConfig = "";
            inherit proxyPass;
          };
          "~ (/jellyfin)?/socket" = {
            extraConfig = "";
            inherit proxyPass;
            proxyWebsockets = true;
          };
        };
    };
  };

  jellyseerr-vhost = generate-vhosts {
    inherit config;
    inherit (seerr) port subdomain;
    overrides = {
      enableAuthelia = false;
      locations."/".proxyPass =
        "${seerr.protocol}://${seerr.ipv4}:${builtins.toString seerr.port}";
    };
  };

  localhost-vhost = {
    localhost = {
      enableAuthelia = false;
      forceSSL = false;
      locations."/" = {
        extraConfig = ''
          allow 127.0.0.1;
          deny all;
        '';
        proxyPass = "https://127.0.0.1/nginx_status";
      };
    };
  };

  nextcloud-vhost = generate-vhosts {
    inherit config;
    service-name = "nextcloud";
    inherit (nextcloud) subdomain;
    overrides = {
      enableAuthelia = false;

      useACMEHost = "rovacsek.com";

      kTLS = true;

      locations."/" = {
        # The below is required as by default nginx will utilise differing
        # max client body sizes - this is simply a copy of the recommended
        # nextcloud proxy config, minus any headers as the response from
        # the second nginx proxy will add these headers
        #
        # Why do we need a dual reverse proxy config, to avoid needing to rewrite large
        # elements of the upstream opinions on nextcloud.
        extraConfig = ''
          index index.php index.html /index.php$request_uri;

          proxy_buffering off;
          proxy_hide_header Referrer-Policy;
          proxy_hide_header X-Content-Type-Options;
          proxy_hide_header X-Frame-Options;
          proxy_hide_header X-XSS-Protection;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Real-IP $remote_addr;

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
      };
    };
  };
in
{
  services.nginx = {
    domains = [ "rovacsek.com" ];

    resolver = {
      addresses =
        (lib.optionals config.services.blocky.enable [
          "127.0.0.1:${builtins.toString config.services.blocky.settings.ports.dns}"
        ])
        ++ (builtins.map (
          n: "${n}:${builtins.toString self.common.config.services.blocky.port}"
        ) self.common.config.services.blocky.nodes);

      ipv4 = true;
      ipv6 = false;
    };

    statusPage = true;

    appendHttpConfig = ''
      proxy_headers_hash_max_size 1024;
      proxy_headers_hash_bucket_size 128;
    '';

    virtualHosts = merge [
      authelia-vhost
      firefox-syncserver-vhost
      harmonia-vhost
      jellyfin-vhost
      jellyseerr-vhost
      localhost-vhost
      nextcloud-vhost
    ];
  };
}
