{ config, pkgs, self, ... }:
let inherit (self.common.networking.services.firefox-syncserver) port;
in {
  age = {
    identityPaths = [ "/agenix/id-ed25519-firefox-syncserver-primary" ];

    secrets."firefox-syncserver-secrets" = {
      file = ../../secrets/firefox-syncserver/secrets.age;
      # Magic value as per: https://github.com/NixOS/nixpkgs/blob/b0d36bd0a420ecee3bc916c91886caca87c894e9/nixos/modules/services/networking/firefox-syncserver.nix#L7
      owner = "firefox-syncserver";
      mode = "0400";
    };
  };

  networking.firewall.allowedTCPPorts = [ port ];

  services = {
    firefox-syncserver = {
      enable = true;
      secrets = config.age.secrets."firefox-syncserver-secrets".path;

      settings = {
        host = "0.0.0.0";
        inherit port;
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
  };
}
