{ config, ... }:
let
  inherit (config.flake.lib.nginx) generate-domains generate-vhosts;
  inherit (config.flake.lib.authelia) generate-access-rules;

  cfg = {
    include-header = false;
    name = "Config";
    value = [
      {
        name = "LogLevel";
        value = config.services.sonarr.logLevel;
      }
      {
        name = "EnableSsl";
        value = if config.services.sonarr.enableSsl then "True" else "False";
      }
      {
        name = "Port";
        value = config.services.sonarr.port;
      }
      {
        name = "SslPort";
        value = config.services.sonarr.sslPort;
      }
      {
        name = "BindAddress";
        value = "*";
      }
      {
        name = "AuthenticationMethod";
        value = config.services.sonarr.authenticationMethod;
      }
      {
        name = "UpdateMechanism";
        value = "BuiltIn";
      }
      {
        name = "Branch";
        value = "main";
      }
      {
        name = "InstanceName";
        value = "Sonarr";
      }
    ];
  };

  cfg-text = config.flake.lib.generators.to-xml cfg;

  inherit (config.services.sonarr) port;

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

  services = {
    authelia.instances =
      generate-access-rules config.services.nginx.domains service-name;

    nginx = {
      test = { inherit domains; };
      inherit virtualHosts;
    };

    sonarr = {
      enable = true;
      openPort = true;
      port = 9999;
    };
  };

  environment.etc."sonarr/config.xml" = {
    inherit (config.services.sonarr) user group;
    text = cfg-text;
    mode = "0750";
  };

  systemd.tmpfiles.rules = [
    "L+ ${config.services.sonarr.dataDir}/config.xml - - - - /etc/sonarr/config.xml"
  ];
}
