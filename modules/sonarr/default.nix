{ config, ... }:
let
  inherit (config.flake.lib.nginx) generate-domains generate-vhosts;
  inherit (config.flake.lib.authelia) generate-access-rules;

  inherit (config.services.sonarr.ports) http;

  port = http;

  service-name = "sonarr";

  domains = generate-domains { inherit config service-name; };

  overrides.locations."~ (/sonarr)?/api" = {
    proxyPass = "http://localhost:${builtins.toString port}";
    recommendedProxySettings = true;
  };

  virtualHosts =
    generate-vhosts { inherit config service-name port overrides; };
in {
  # Extended options for nginx and sonarr
  imports = [ ../../options/nginx ../../options/sonarr ];

  services = {
    authelia.instances =
      generate-access-rules config.services.nginx.domains service-name;

    nginx = {
      test = { inherit domains; };
      inherit virtualHosts;
    };

    sonarr = {
      enable = true;
      openPort = true;
      ports.http = 9999;
      use-declarative-settings = true;
    };
  };
}
