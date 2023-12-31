{ config, ... }:
let
  inherit (config.flake.lib.nginx) generate-vhosts;
  inherit (config.flake.lib.authelia) generate-access-rules;

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

  pfsense-vhost = generate-vhosts {
    inherit config;
    service-name = "pfsense";
    port = 0;
    overrides = { locations."/" = { proxyPass = "https://192.168.1.1:443"; }; };
  };

  authelia-pfsense =
    generate-access-rules config.services.nginx.domains "pfsense";

  portainer-vhost = generate-vhosts {
    inherit config;
    service-name = "portainer";
    port = 0;
    overrides = {
      locations."/" = { proxyPass = "http://192.168.1.220:9000"; };
    };
  };

  authelia-portainer =
    generate-access-rules config.services.nginx.domains "portainer";

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

in {
  services = {
    authelia.instances = authelia-pfsense // authelia-portainer;

    nginx.virtualHosts = headscale-vhost // pfsense-vhost // nextcloud-vhost
      // portainer-vhost;
  };
}
