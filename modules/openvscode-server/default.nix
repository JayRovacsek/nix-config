{ config, ... }: {

  age = {
    identityPaths = [ "/agenix/id-ed25519-openvscode-server-primary" ];

    secrets.openvscode-serverConnectionTokenFile = {
      file = ../../secrets/openvscode-server/connection-token-file.age;
      owner = config.services.openvscode-server.user;
      inherit (config.services.openvscode-server) group;
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ config.services.openvscode-server.port ];
  };

  services.openvscode-server = {
    enable = true;
    telemetryLevel = "off";
    host = "0.0.0.0";
    connectionTokenFile =
      config.age.secrets.openvscode-serverConnectionTokenFile.path;
  };
}
