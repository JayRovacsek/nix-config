{ config, pkgs, ... }:
let
  inherit (config.flake.lib) certificates;

  certificate-lib = certificates pkgs;

  inherit (certificate-lib) generate-self-signed;

  self-signed-certificate = generate-self-signed "test.rovacsek.com";

  # Catch for testing spaces
  testing = config.networking.hostName == "alakazam";

  virtualHostConfigs = builtins.filter (x: x != "template.nix")
    (builtins.attrNames (builtins.readDir ./virtualHosts));

  tld = if testing then "test.rovacsek.com" else "rovacsek.com";

  virtualHosts = builtins.foldl' (x: y: x // y) { } (builtins.map (x:
    let
      overrides =
        if testing then { sslCertificate = self-signed-certificate; } else { };
    in import ./virtualHosts/${x} { inherit config tld overrides; })
    virtualHostConfigs);

  port = 443;

in {
  networking.firewall.allowedTCPPorts = [ port ];

  # testing imports TODO: remove
  imports = [ ../download-utilities ];

  services.nginx = {
    enable = true;
    enableReload = true;
    recommendedTlsSettings = true;
    recommendedZstdSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    recommendedBrotliSettings = true;

    virtualHosts = {
      default = {
        onlySSL = true;
        sslCertificate = "${self-signed-certificate}/share/self-signed.crt";
        sslCertificateKey = "${self-signed-certificate}/share/privkey.key";
        serverName = "_";
        locations."/" = { return = "404"; };
      };

      jellyseerr = {
        onlySSL = true;
        sslCertificate = "${self-signed-certificate}/share/self-signed.crt";
        sslCertificateKey = "${self-signed-certificate}/share/privkey.key";
        serverName = "jellyseerr.test.rovacsek.com";
        locations."/" = {
          proxyPass = "http://localhost:${
              builtins.toString config.services.jellyseerr.port
            }";
          recommendedProxySettings = true;
        };
      };

      lidarr = {
        onlySSL = true;
        sslCertificate = "${self-signed-certificate}/share/self-signed.crt";
        sslCertificateKey = "${self-signed-certificate}/share/privkey.key";
        serverName = "lidarr.test.rovacsek.com";
        locations."/" = {
          proxyPass = "http://localhost:8686";
          recommendedProxySettings = true;
        };
      };

      prowlarr = {
        onlySSL = true;
        sslCertificate = "${self-signed-certificate}/share/self-signed.crt";
        sslCertificateKey = "${self-signed-certificate}/share/privkey.key";
        serverName = "prowlarr.test.rovacsek.com";
        locations."/" = {
          proxyPass = "http://localhost:9696";
          recommendedProxySettings = true;
        };
      };

      radarr = {
        onlySSL = true;
        sslCertificate = "${self-signed-certificate}/share/self-signed.crt";
        sslCertificateKey = "${self-signed-certificate}/share/privkey.key";
        serverName = "radarr.test.rovacsek.com";
        locations."/" = {
          proxyPass = "http://localhost:7878";
          recommendedProxySettings = true;
        };
      };

      sonarr = {
        onlySSL = true;
        sslCertificate = "${self-signed-certificate}/share/self-signed.crt";
        sslCertificateKey = "${self-signed-certificate}/share/privkey.key";
        serverName = "sonarr.test.rovacsek.com";
        locations."/" = {
          proxyPass = "http://localhost:8989";
          recommendedProxySettings = true;
        };
      };
    };
  };
}
