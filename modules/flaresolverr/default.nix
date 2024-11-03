{ pkgs, self, ... }:
let
  inherit (pkgs) system;
  inherit (self.inputs.flaresolverr-pin.legacyPackages.${system}) flaresolverr;
in
{
  services.flaresolverr = {
    enable = true;
    openFirewall = true;
    package = flaresolverr;
    inherit (self.common.config.services.flaresolverr) port;
  };
}
