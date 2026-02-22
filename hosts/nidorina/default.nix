{ config, self, ... }:
{
  imports =
    (with self.nixosModules; [
      acme
      agenix
      alloy
      ddclient
      microvm-guest
      nginx
      nix-topology
      time
      timesyncd
      tmp-tmpfs
    ])
    ++ [ ./nginx.nix ];

  microvm = {
    interfaces = [
      {
        type = "macvtap";
        id = config.networking.hostName;
        mac = "02:42:c0:a8:05:03";
        macvtap = {
          link = "reverse-proxy";
          mode = "bridge";
        };
      }
    ];

    mem = 4096;
  };

  networking.hostName = "nidorina";

  system.stateVersion = "24.05";
}
