{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (self.common.config.services.firefox-syncserver) port;
in
{
  age = {
    identityPaths = [ "/agenix/id-ed25519-firefox-syncserver-primary" ];

    secrets."firefox-syncserver-secrets" = {
      file = ../../secrets/firefox-syncserver/secrets.age;
      mode = "0400";
    };
  };

  networking.firewall.allowedTCPPorts = [ port ];

  services = {
    firefox-syncserver = {
      enable = true;

      # TEMPORARY: need to ping to old stable version until upstream fixes are applied
      # as per https://github.com/NixOS/nixpkgs/issues/540669
      package = self.inputs.stable.legacyPackages.${pkgs.system}.syncstorage-rs;

      secrets = config.age.secrets."firefox-syncserver-secrets".path;

      settings = {
        host = "0.0.0.0";
        inherit port;
        syncstorage.database_url = "mysql://firefox-syncserver@localhost/firefox_syncserver?socket=%2Frun%2Fmysqld%2Fmysqld.sock";
        tokenserver.database_url = "mysql://firefox-syncserver@localhost/firefox_syncserver?socket=%2Frun%2Fmysqld%2Fmysqld.sock";
      };
      logLevel = "error";
      singleNode = {
        enable = true;
        enableNginx = true;
        enableTLS = true;
        hostname = "firefox-syncserver.rovacsek.com";
      };
    };

    mysql.package = pkgs.mariadb;

    nginx.virtualHosts = {
      "firefox-syncserver.rovacsek.com" = {
        enableACME = lib.mkForce false;
      };
    };
  };
}
