{ config, self, ... }:
{
  imports = with self.nixosModules; [
    agenix
    bazarr
    grafana-agent
    microvm-guest
    nix-topology
    time
    timesyncd
  ];

  microvm = {
    interfaces = [
      {
        type = "macvtap";
        id = config.networking.hostName;
        mac = "02:42:c0:a8:04:8b";
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
        source = "/srv/movies";
        # In the MicroVM
        mountPoint = "/srv/movies";
        tag = "movies";
        proto = "virtiofs";
      }
      {
        # On the host
        source = "/srv/tv";
        # In the MicroVM
        mountPoint = "/srv/tv";
        tag = "tv";
        proto = "virtiofs";
      }
    ];
  };

  networking.hostName = "oddish";

  services.bazarr = {
    group = "media";
    user = "bazarr";
  };

  system.stateVersion = "24.11";

  users = {
    inherit (self.common.config.services.media) groups users;
  };
}
