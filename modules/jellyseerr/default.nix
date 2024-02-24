{ self, ... }: {
  services = {
    jellyseerr = {
      enable = true;
      openFirewall = true;

      inherit (self.common.networking.services.jellyseerr) port;
    };
  };
}
