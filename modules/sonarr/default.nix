{ config, ... }:
let
  cfg = config.flake.lib.generators.to-xml {
    Config = {
      LogLevel = "info";
      EnableSsl = "False";
      Port = 8989;
      SslPort = 9898;
      BindAddress = "*";
      # The below is not a live key. It will be changed prior to deploy
      ApiKey = "85e1526d459348f8a92d3b1a7f67286f";
      AuthenticationMethod = "None";
      UpdateMechanism = "BuiltIn";
      Branch = "main";
      InstanceName = "Sonarr";
    };
  };
in {
  services.sonarr = {
    enable = true;
    openFirewall = true;
    dataDir = "/etc/sonarr";
  };

  environment.etc."sonarr/config.xml" = {
    inherit (config.services.sonarr) user group;
    text = cfg;
    mode = "0750";
  };
}
