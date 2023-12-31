{ config, ... }:
let
  inherit (config.flake.lib.nginx) generate-domains generate-vhosts;
  inherit (config.flake.lib.authelia) generate-access-rules;

  service-name = "lidarr";

  port = 8686;

  domains = generate-domains { inherit config service-name; };

  overrides.locations."~ (/lidarr)?/api" = {
    extraConfig = "";
    proxyPass = "http://localhost:${builtins.toString port}";
  };

  virtualHosts = generate-vhosts {
    inherit config overrides port service-name;
    # port = config.services.lidarr.ports.http;
  };
in {
  # Extended options for nginx
  # TODO: map lidarr settings to custom options
  imports = [ ../../options/jellyfin ../../options/nginx ];

  services = {
    authelia.instances =
      generate-access-rules config.services.nginx.domains service-name;

    lidarr = {
      enable = true;
      openFirewall = true;
      # Below to be changed prior to deploy
      # group = "";
      # user = "";
      # dataDir = "/mnt/zfs/containers/lidarr";
    };

    nginx = {
      test = { inherit domains; };
      inherit virtualHosts;
    };
  };
}
