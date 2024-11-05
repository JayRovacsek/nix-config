{ self, ... }:
{
  services.flaresolverr = {
    enable = true;
    openFirewall = true;
    inherit (self.common.config.services.flaresolverr) port;
  };
}
