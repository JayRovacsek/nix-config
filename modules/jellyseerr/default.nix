{ self, ... }:
{
  services = {
    jellyseerr = {
      enable = true;
      openFirewall = true;

      inherit (self.common.config.services.jellyseerr) port;
    };
  };
}
