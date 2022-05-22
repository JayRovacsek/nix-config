{
  networking.wireless.environmentFile = "/secrets/wireless.env";
  networking.wireless = {
    enable = true;
    interfaces = [ "wlan0" ];
    networks."@IOT_SSID@".psk = "@IOT_PSK@";
  };
}
