{ config, pkgs, ... }: {
  services.deluge = {
    enable = true;
    declarative = true;
    openFirewall = true;
    authFile = "${pkgs.writeText "user" "password"}";
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ config.services.deluge.web.port ];
  };
}
