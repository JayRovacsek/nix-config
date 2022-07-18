{ config, primaryDomain ? "rovacsek.com", tlds ? [ primaryDomain ]
, subdomains ? [ ], ... }:
let
  tldCertConfigs =
    builtins.map (tld: { "${tld}" = { listenHTTP = ":80"; }; }) tlds;

  subdomainCertConfigs =
    builtins.map (subdomain: { "${subdomain}" = { listenHTTP = ":80"; }; })
    subdomains;

  certs =
    builtins.foldl' (x: y: x // y) { } (tldCertConfigs ++ subdomainCertConfigs);

  defaults = {
    email = "acme@${primaryDomain}";
    group = config.services.nginx.group;
  };
in {
  security.acme = {

    inherit certs defaults;
    acceptTerms = true;
  };
}
