{ pkgs, ... }:
{
  services.gammastep = {
    enable = true;
    enableVerboseLogging = false;
    package = pkgs.gammastep;
    latitude = -32.917;
    longitude = 151.8;
    temperature = {
      day = 6000;
      night = 3700;
    };
    settings = {
      general = {
        brightness-day = "1";
        brightness-night = "0.6";
        adjustment-method = "wayland";
      };
    };
    tray = false;
  };
}
