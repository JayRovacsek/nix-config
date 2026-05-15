{ self, ... }:
{
  services = {
    seerr = {
      enable = true;
      openFirewall = true;

      inherit (self.common.config.services.seerr) port;
    };
  };
}
