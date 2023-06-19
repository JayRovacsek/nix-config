{ config, ... }: {

  networking.firewall = {
    allowedTCPPorts = [ services.openvscode-server.port ];
  };

  services.openvscode-server = {
    enable = true;
    telemetryLevel = "off";
    host = "0.0.0.0";
    connectionTokenFile =
      config.age.secrets.openvscode-serverConnectionTokenFile.path;
  };
}
