{ config, self, ... }:
{
  imports = with self.nixosModules; [
    agenix
    alloy
    lidarr
    microvm-guest
    nix-topology
    time
    timesyncd
  ];

  networking.hostName = "machop";

  microvm = {
    interfaces = [
      {
        type = "macvtap";
        id = config.networking.hostName;
        mac = "02:42:c0:a8:04:85";
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
        source = "/srv/music";
        # In the MicroVM
        mountPoint = "/srv/music";
        tag = "music";
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

  services.lidarr = {
    group = "media";
    user = "media";
  };

  system.stateVersion = "24.05";

  users = {
    inherit (self.common.config.services.media) groups users;
  };
}
