{ self, ... }:
let
  inherit (self.common.config.services) bedrock-connect minecraft;
in
{
  imports = [
    ../../options/modules/bedrock-connect
  ];

  services.blocky.settings.customDNS.mapping = {
    "geo.hivebedrock.network" = minecraft.ipv4;
    "hivebedrock.network" = minecraft.ipv4;
    "play.inpvp.net" = minecraft.ipv4;
    "mco.lbsg.net" = minecraft.ipv4;
    "play.galaxite.net" = minecraft.ipv4;
    "play.enchanted.gg" = minecraft.ipv4;
  };

  networking.firewall.allowedUDPPorts = [ bedrock-connect.port ];

  services.bedrock-connect = {
    enable = true;
    servers = [
      {
        name = "Home Server";
        iconUrl = "https://i.imgur.com/nhumQVP.png";
        address = minecraft.ipv4;
        port = minecraft.bedrock-port;
      }
    ];
  };
}
