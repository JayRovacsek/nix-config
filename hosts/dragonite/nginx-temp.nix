{ config, ... }:
let
  inherit (config.flake.lib.nginx) generate-vhosts;
  inherit (config.flake.lib.authelia) generate-access-rules;

  service-name = "pfsense";

  pfsense-vhost = generate-vhosts {
    inherit config;
    service-name = "pfsense";
    port = 0;
    overrides = { locations."/" = { proxyPass = "https://192.168.1.1:443"; }; };
  };
in {
  services = {
    authelia.instances =
      generate-access-rules config.services.nginx.domains service-name;

    nginx.virtualHosts = pfsense-vhost;
  };
}
