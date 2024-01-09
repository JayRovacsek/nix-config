{ config, lib, ... }:
let
  inherit (config.flake.lib.nginx) generate-domains generate-vhosts;

  inherit (config.services.sonarr.ports) http;

  port = http;

  service-name = "sonarr";

  domains = generate-domains { inherit config service-name; };

  overrides.locations."~ (/sonarr)?/api" = {
    proxyPass = "http://localhost:${builtins.toString port}";
    recommendedProxySettings = true;
  };

  virtualHosts =
    generate-vhosts { inherit config service-name port overrides; };
in {
  # Extended options for nginx and sonarr
  imports = [ ../../options/nginx ../../options/sonarr ];

  age = {
    identityPaths = [ "/agenix/id-ed25519-sonarr-primary" ];

    secrets."sonarr-api-key" = lib.mkForce {
      file = ../../secrets/sonarr/api-key.age;
      owner = config.services.sonarr.user;
      mode = "0400";
    };
  };

  services = {
    nginx = {
      test = { inherit domains; };
      inherit virtualHosts;
    };

    sonarr = {
      enable = true;
      api-key-file = config.age.secrets.sonarr-api-key.path;
      openPort = true;
      ports.http = 9999;
      use-declarative-settings = true;
    };
  };
}
