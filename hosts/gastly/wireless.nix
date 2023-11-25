{ config, ... }: {
  age = {
    identityPaths = [ "/agenix/id-ed25519-wireless-primary" ];

    secrets."wireless.env" = {
      file = ../../secrets/wireless/wireless-pixel-hotspot.env.age;
      mode = "0400";
    };
  };

  networking = {
    hostName = "gastly";
    wireless = {
      enable = true;
      environmentFile = config.age.secrets."wireless.env".path;
      interfaces = [ "wlp58s0" ];
      networks."@SSID@" = {
        psk = "@PSK@";
        priority = 10;
        authProtocols = [ "WPA-PSK" ];
      };
    };
  };
}
