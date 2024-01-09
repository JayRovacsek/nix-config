{ config, ... }:
let
  inherit (config.flake.lib.nginx) generate-domains generate-vhosts;
  inherit (config.flake.lib.authelia) generate-access-rules;

  service-name = "jellyseerr";

  domains = generate-domains { inherit config service-name; };

  virtualHosts = generate-vhosts {
    inherit config service-name;
    inherit (config.services.jellyseerr) port;
  };
in {
  # Extended options for nginx
  imports = [ ../../options/nginx ];

  services = {
    authelia.instances =
      generate-access-rules config.services.nginx.domains service-name;

    jellyseerr = {
      enable = true;
      port = 5055;
      openFirewall = true;
    };

    nginx = {
      test = { inherit domains; };
      inherit virtualHosts;
    };
  };
}
