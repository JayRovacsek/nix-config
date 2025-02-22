{ config, self, ... }:
{
  services.home-assistant = {
    config = {
      homeassistant = {
        name = "Home";
        temperature_unit = "C";
        time_zone = config.time.timeZone;
        unit_system = "metric";
      };
      http = {
        server_host = "127.0.0.1";
        server_port = self.common.config.services.home-assistant.port;
        trusted_proxies = [
          self.common.config.services.nginx.ipv4
        ];
        use_x_forwarded_for = true;
      };
    };
    configDir = "/var/lib/hass";
    configWritable = false;
    customComponents = [ ];
    customLovelaceModules = [ ];
    enable = true;
    extraArgs = [ ];
    extraComponents = [
      "cloud"
      "generic"
      "google_translate"
      "isal"
      "met"
      "radio_browser"
    ];

    lovelaceConfig = {

    };
    lovelaceConfigWritable = false;
    openFirewall = true;
  };
}
