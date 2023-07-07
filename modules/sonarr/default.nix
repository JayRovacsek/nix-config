{ config, ... }:
let

  cfg = {
    Config = {
      LogLevel = config.services.sonarr.logLevel;
      EnableSsl = if config.services.sonarr.enableSsl then "True" else "False";
      Port = config.services.sonarr.port;
      SslPort = config.services.sonarr.sslPort;
      BindAddress = "*";
      # The below is not a live key. It will be changed prior to deploy
      ApiKey = "85e1526d459348f8a92d3b1a7f67286f";
      AuthenticationMethod = config.services.sonarr.authenticationMethod;
      UpdateMechanism = "BuiltIn";
      Branch = "main";
      InstanceName = "Sonarr";
    };
  };

  cfg-text = config.flake.lib.generators.to-xml cfg;
in {
  imports = [ ../../options/sonarr ];

  services.sonarr = {
    enable = true;
    dataDir = "/etc/sonarr";
    openPort = true;
    port = 9999;
  };

  environment.etc."sonarr/config.xml" = {
    inherit (config.services.sonarr) user group;
    text = cfg-text;
    mode = "0750";
  };
}
