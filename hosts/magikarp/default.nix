{ config, self, ... }:
{
  imports = with self.nixosModules; [
    agenix
    grafana-agent
    headscale
    microvm-guest
    nix-topology
    time
    timesyncd
  ];

  age.identityPaths = [ "/agenix/id-ed25519-magikarp-primary" ];

  networking.hostName = "magikarp";

  microvm = {
    interfaces = [
      {
        type = "macvtap";
        id = config.networking.hostName;
        mac = "02:42:c0:a8:19:02";
        macvtap = {
          link = "headscale";
          mode = "bridge";
        };
      }
    ];
  };

  system.stateVersion = "24.05";
}
