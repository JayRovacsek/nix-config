{ tld ? "rovacsek.com" }:
let
  subdomain = "headscale";
  # TODO: not have localhost here once this is microvm'd
  target = "localhost";
  port = 8080;
  scheme = "http";
in {
  "${subdomain}.${tld}" = {
    forceSSL = true;
    useACMEHost = tld;
    locations."/" = {
      proxyPass = "${scheme}://${target}:${builtins.toString port}";
      recommendedProxySettings = true;
    };
  };
}
