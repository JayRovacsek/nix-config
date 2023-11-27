{ config, ... }:
let

  cfg = {
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
        name = "ApiKey";
        value = "85e1526d459348f8a92d3b1a7f67286f";
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
in {
  imports = [ ../../options/sonarr ];

  services.sonarr = {
    enable = true;
    openPort = true;
    port = 9999;
  };

  environment.etc."sonarr/config.xml" = {
    inherit (config.services.sonarr) user group;
    text = cfg-text;
    mode = "0750";
  };

  systemd.tmpfiles.rules = [
    "L+ ${config.services.sonarr.dataDir}/dlna.xml - - - - /etc/sonarr/config/config.xml"
  ];
}
