{ config, tld ? "rovacsek.com" }:
let
  subdomain = "home-assistant";
  fqdn = "${subdomain}.${tld}";
  # We assume the host we are proxying, to have a hostname matching the
  # subdomain - otherwise change this bad-boy
  target = "${subdomain}.${
      if builtins.hasAttr "localDomain" config.networking then
        config.networking.localDomain
      else
        ""
    }";
  port = 8123;
  scheme = "http";
in {
  "${subdomain}.${tld}" = {
    forceSSL = true;
    useACMEHost = fqdn;
    locations = {
      "/" = {
        proxyPass = "${scheme}://${target}:${builtins.toString port}";
        extraConfig = "include /etc/nginx/modules/authelia-location.conf;";
        recommendedProxySettings = true;
      };

      "/api" = {
        proxyPass = "${scheme}://${target}:${builtins.toString port}";
        recommendedProxySettings = true;
      };

      "/local" = {
        proxyPass = "${scheme}://${target}:${builtins.toString port}";
        recommendedProxySettings = true;
      };
    };
    # This enables authelia on the server.
    extraConfig = "include /etc/nginx/modules/authelia-server.conf;";
  };
}
