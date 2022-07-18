{ config, primaryDomain ? "rovacsek.com", tlds ? [ primaryDomain ]
, subdomains ? [ ], ... }:
let
  port = 10080;

  tldCertConfigs = builtins.map
    (tld: { "${tld}" = { listenHTTP = ":${builtins.toString port}"; }; }) tlds;

  subdomainCertConfigs = builtins.map (subdomain: {
    "${subdomain}" = { listenHTTP = ":${builtins.toString port}"; };
  }) subdomains;

  certs =
    builtins.foldl' (x: y: x // y) { } (tldCertConfigs ++ subdomainCertConfigs);

  defaults = {
    email = "acme@${primaryDomain}";
    group = config.services.nginx.group;
  };
in {
  networking.firewall.allowedTCPPorts = [ port ];

  security.acme = {

    inherit certs defaults;
    acceptTerms = true;
  };
}
