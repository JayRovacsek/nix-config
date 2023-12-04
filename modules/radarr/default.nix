{ config, ... }:
let
  inherit (config.flake.lib.nginx) generate-domains generate-vhosts;
  inherit (config.flake.lib.authelia) generate-access-rules;

  service-name = "radarr";

  domains = generate-domains { inherit config service-name; };

  virtualHosts = generate-vhosts {
    inherit config service-name;
    # port = config.services.radarr.ports.http;
    port = 7878;
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
