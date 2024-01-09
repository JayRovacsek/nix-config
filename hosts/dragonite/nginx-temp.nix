{ config, ... }:
let
  inherit (config.flake.lib) merge;
  inherit (config.flake.lib.nginx) generate-vhosts;
  inherit (config.flake.lib.authelia)
    generate-test-access-rules generate-prod-access-rules;

  deluge-vhost = generate-vhosts {
    inherit config;
    service-name = "deluge";
    port = 0;
    overrides = {
      locations."/" = { proxyPass = "http://192.168.4.130:8112"; };
    };
  };

  deluge-prod-authelia =
    generate-prod-access-rules config.services.nginx.domains "deluge";
  deluge-test-authelia =
    generate-test-access-rules config.services.nginx.domains "deluge";

  headscale-vhost = generate-vhosts {
    inherit config;
    service-name = "headscale";
    port = 0;
    overrides = {
      locations."/" = {
        extraConfig = "";
        proxyPass = "http://127.0.0.1:${
            builtins.toString config.services.headscale.port
          }";
        proxyWebsockets = true;
      };
    };
  };

  nextcloud-vhost = generate-vhosts {
    inherit config;
    service-name = "nextcloud";
    port = 0;
    overrides = {
      locations."/" = {
        extraConfig = ''
          proxy_hide_header X-Frame-Options;
          proxy_max_temp_file_size 2048m;
        '';
        proxyPass = "https://192.168.10.2";
      };
    };
  };

  pfsense-vhost = generate-vhosts {
    inherit config;
    service-name = "pfsense";
    port = 0;
    overrides = { locations."/" = { proxyPass = "https://192.168.1.1:443"; }; };
  };

  pfsense-prod-authelia =
    generate-prod-access-rules config.services.nginx.domains "pfsense";
  pfsense-test-authelia =
    generate-test-access-rules config.services.nginx.domains "pfsense";

  portainer-vhost = generate-vhosts {
    inherit config;
    service-name = "portainer";
    port = 0;
    overrides = {
      locations."/" = { proxyPass = "http://192.168.1.220:9000"; };
    };
  };

  portainer-prod-authelia =
    generate-prod-access-rules config.services.nginx.domains "portainer";
  portainer-test-authelia =
    generate-test-access-rules config.services.nginx.domains "portainer";

  prowlarr-vhost = generate-vhosts {
    inherit config;
    service-name = "prowlarr";
    port = 0;
    overrides = {
      locations = {
        "/" = { proxyPass = "http://192.168.4.137:9696"; };
        "~ (/prowlarr)?(/[0-9]+)?/api" = {
          extraConfig = "";
          proxyPass = "http://192.168.4.137:9696";
        };

      };
    };
  };

  prowlarr-prod-authelia =
    generate-prod-access-rules config.services.nginx.domains "prowlarr";
  prowlarr-test-authelia =
    generate-test-access-rules config.services.nginx.domains "prowlarr";

in {
  services = {
    authelia.instances.production.settings.access_control.rules =
      deluge-prod-authelia ++ pfsense-prod-authelia ++ portainer-prod-authelia
      ++ prowlarr-prod-authelia;

    authelia.instances.test.settings.access_control.rules = deluge-test-authelia
      ++ pfsense-test-authelia ++ portainer-test-authelia
      ++ prowlarr-test-authelia;

    nginx.virtualHosts = merge [
      deluge-vhost
      headscale-vhost
      nextcloud-vhost
      pfsense-vhost
      portainer-vhost
      prowlarr-vhost
    ];
  };
}
