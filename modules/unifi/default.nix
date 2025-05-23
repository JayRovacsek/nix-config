{ pkgs, self, ... }:
{
  networking.firewall.allowedTCPPorts = [
    self.common.config.services.unifi.port
  ];

  services.unifi = {
    enable = true;
    extraJvmOptions = [ "-Djava.net.preferIPv4Stack=true" ];
    openFirewall = true;
    unifiPackage = pkgs.unifi8;
    mongodbPackage = pkgs.mongodb-ce;
  };
}
