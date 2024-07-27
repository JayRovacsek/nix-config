{ self, ... }: {
  services.flaresolverr = {
    enable = true;
    openFirewall = true;
    inherit (self.common.networking.services.flaresolverr) port;
  };
}
