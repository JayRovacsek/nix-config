{ pkgs, self, ... }:
{
  services.flaresolverr = {
    enable = true;
    openFirewall = true;
    package = pkgs.nur.repos.xddxdd.flaresolverr-21hsmw;
    inherit (self.common.config.services.flaresolverr) port;
  };
}
