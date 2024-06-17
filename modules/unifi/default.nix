{ pkgs, self, ... }: {
  networking.firewall.allowedTCPPorts =
    [ self.common.networking.services.unifi.port ];

  services.unifi = {
    enable = true;
    extraJvmOptions = [ "-Djava.net.preferIPv4Stack=true" ];
    openFirewall = true;
    unifiPackage = pkgs.unifi8;
  };
}
