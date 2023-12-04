{ config, ... }:
let
  inherit (config.flake.lib.nginx) generate-domains generate-vhosts;
  inherit (config.flake.lib.authelia) generate-access-rules;

  service-name = "prowlarr";

  domains = generate-domains { inherit config service-name; };

  virtualHosts = generate-vhosts {
    inherit config service-name;
    # port = config.services.prowlarr.ports.http;
    port = 9696;
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
