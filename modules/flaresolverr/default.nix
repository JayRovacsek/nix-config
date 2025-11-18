{ pkgs, self, ... }:
{
  services.flaresolverr = {
    enable = true;
    openFirewall = true;
    package = pkgs.flaresolverr;
    inherit (self.common.config.services.flaresolverr) port;
  };
}
