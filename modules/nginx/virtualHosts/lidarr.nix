{ config, tld ? "rovacsek.com" }:
let
  subdomain = "lidarr";
  fqdn = "${subdomain}.${tld}";
  target = "${subdomain}.${
      if builtins.hasAttr "localDomain" config.networking then
        config.networking.localDomain
      else
        ""
    }";
  port = 8686;
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

      "~ (/lidarr)?/api" = {
        proxyPass = "${scheme}://${target}:${builtins.toString port}";
        recommendedProxySettings = true;
      };
    };
    extraConfig = "include /etc/nginx/modules/authelia-server.conf;";
  };
}
