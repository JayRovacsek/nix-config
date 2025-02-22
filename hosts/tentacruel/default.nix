{ config, self, ... }:
{
  imports = with self.nixosModules; [
    agenix
    grafana-agent
    home-assistant
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
        mac = "02:42:c0:a8:0c:02";
        macvtap = {
          link = "home-assistant";
          mode = "bridge";
        };
      }
    ];

    mem = 4096;

    shares = [
      {
        # On the host
        source = "/srv/home_assistant";
        # In the MicroVM
        mountPoint = "/srv/home_assistant";
        tag = "home_assistant";
        proto = "virtiofs";
      }
    ];
    vcpu = 2;
  };

  networking.hostName = "tentacruel";

  system.stateVersion = "24.11";
}
