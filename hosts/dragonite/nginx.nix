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
      proxyPass =
        "http://127.0.0.1:${builtins.toString config.services.headscale.port}";
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
    overrides.locations."/" = {
      extraConfig = ''
        proxy_hide_header X-Frame-Options;
        proxy_max_temp_file_size 2048m;
      '';
      proxyPass = "https://192.168.10.2";
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
