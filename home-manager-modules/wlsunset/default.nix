{ pkgs, ... }:
{
  services.wlsunset = {
    enable = true;
    package = pkgs.wlsunset;
    gamma = "1";
    latitude = "-32.917";
    longitude = "151.8";
    systemdTarget = "graphical-session.target";
    temperature = {
      day = 6500;
      night = 3500;
    };
  };
}
