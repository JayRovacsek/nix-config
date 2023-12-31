{ config, ... }:
let
  inherit (config.flake.lib.nginx) generate-domains generate-vhosts;
  inherit (config.flake.lib.authelia) generate-access-rules;

  service-name = "radarr";

  port = 7878;

  domains = generate-domains { inherit config service-name; };

  overrides.locations."~ (/radarr)?/api" = {
    extraConfig = "";
    proxyPass = "http://localhost:${builtins.toString port}";
  };

  virtualHosts = generate-vhosts {
    inherit config service-name overrides port;
    # port = config.services.radarr.ports.http;
  };
in {
  # Extended options for nginx
  # TODO: map radarr settings to custom options
  imports = [ ../../options/nginx ];
  services = {
    authelia.instances =
      generate-access-rules config.services.nginx.domains service-name;

    nginx = {
      test = { inherit domains; };
      inherit virtualHosts;
    };

    radarr = {
      enable = true;
      openFirewall = true;
      # Below to be changed prior to deploy
      # group = "";
      # user = "";
      # dataDir = "/mnt/zfs/containers/radarr";
    };
  };
}
