{ config, tld ? "rovacsek.com" }:
let
  subdomain = "authelia";
  fqdn = "${subdomain}.${tld}";
  # We assume the host we are proxying, to have a hostname matching the
  # subdomain - otherwise change this bad-boy
  target = "${subdomain}.${
      if builtins.hasAttr "localDomain" config.networking then
        config.networking.localDomain
      else
        ""
    }";
  port = 9091;
  scheme = "http";
in {
  "${fqdn}" = {
    forceSSL = true;
    useACMEHost = fqdn;
    locations."/" = {
      proxyPass = "${scheme}://${target}:${builtins.toString port}";
      recommendedProxySettings = true;
    };
  };
}
