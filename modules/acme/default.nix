{ config, lib, ... }:
let
  inherit (config.flake.lib) merge;

  port = 10080;

  certs = merge (builtins.map (tld: {
    "${tld}" = {
      extraDomainNames = [ "*.${tld}" ];
      listenHTTP = ":${builtins.toString port}";
      reloadServices = [ "nginx" ];
    };
  }) config.services.nginx.domains);

  prod = !config.services.nginx.test.enable;
in {
  networking.firewall.allowedTCPPorts = lib.mkIf prod [ port ];

  security.acme = lib.mkIf prod {
    acceptTerms = true;

    inherit certs;

    defaults = {
      inherit (config.services.nginx) group;
      email = "acme@rovacsek.com";
    };
  };
}
