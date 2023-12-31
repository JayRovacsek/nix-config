{ config, ... }:
let
  inherit (config.flake.lib.nginx) generate-domains generate-vhosts;
  inherit (config.flake.lib.authelia) generate-access-rules;

  service-name = "prowlarr";

  port = 9696;

  domains = generate-domains { inherit config service-name; };

  overrides.locations."~ (/prowlarr)?(/[0-9]+)?/api".proxyPass =
    "http://localhost:${builtins.toString port}";

  virtualHosts = generate-vhosts {
    inherit config service-name overrides port;
    # port = config.services.prowlarr.ports.http;
  };
in {
  # Extended options for nginx
  # TODO: map prowlarr settings to custom options
  imports = [ ../../options/nginx ];
  services = {
    authelia.instances =
      generate-access-rules config.services.nginx.domains service-name;

    nginx = {
      test = { inherit domains; };
      inherit virtualHosts;
    };

    prowlarr = {
      enable = true;
      openFirewall = true;
    };
  };
}
