{
  config,
  self,
  pkgs,
  ...
}:
{
  networking.firewall.allowedTCPPorts = [ 8123 ];

  services.home-assistant = {
    config = {
      homeassistant = {
        name = "Home";
        temperature_unit = "C";
        time_zone = config.time.timeZone;
        unit_system = "metric";
      };
      http = {
        auth_oidc = {
          client_id = "home-assistant";
          client_secret = "REPLACE_ME";
          discovery_url = "https://authelia.rovacsek.com/.well-known/openid-configuration";
          display_name = "Authelia";
        };
        server_host = "auto";
        server_port = self.common.config.services.home-assistant.port;
        trusted_proxies = [
          self.common.config.services.nginx.ipv4
        ];
        use_x_forwarded_for = true;
      };
    };
    configDir = "/var/lib/hass";
    configWritable = false;
    customComponents = [ pkgs.home-assistant-custom-components.auth_oidc ];
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
    openFirewallForComponents = true;
  };
}
