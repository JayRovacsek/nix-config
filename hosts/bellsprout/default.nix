{ config, self, ... }:
{
  imports = with self.nixosModules; [
    agenix
    alloy
    microvm-guest
    nix-topology
    sonarr
    time
    timesyncd
  ];

  microvm = {
    interfaces = [
      {
        type = "macvtap";
        id = config.networking.hostName;
        mac = "02:42:c0:a8:04:83";
        macvtap = {
          link = "download";
          mode = "bridge";
        };
      }
    ];

    mem = 1024;

    shares = [
      {
        # On the host
        source = "/srv/tv";
        # In the MicroVM
        mountPoint = "/srv/tv";
        tag = "tv";
        proto = "virtiofs";
      }
      {
        # On the host
        source = "/srv/downloads";
        # In the MicroVM
        mountPoint = "/srv/downloads";
        tag = "linux-isos";
        proto = "virtiofs";
      }
    ];
  };

  networking.hostName = "bellsprout";

  services.sonarr = {
    group = "media";
    user = "media";
    authenticationMethod = "External";
  };

  system.stateVersion = "24.05";

  users = {
    inherit (self.common.config.services.media) groups users;
  };
}
