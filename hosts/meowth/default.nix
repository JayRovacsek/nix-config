{ config, self, ... }:
{
  imports = with self.nixosModules; [
    agenix
    alloy
    microvm-guest
    nix-topology
    prowlarr
    time
    timesyncd
  ];

  networking.hostName = "meowth";

  microvm = {
    interfaces = [
      {
        type = "macvtap";
        id = config.networking.hostName;
        mac = "02:42:c0:a8:04:89";
        macvtap = {
          link = "download";
          mode = "bridge";
        };
      }
    ];

    mem = 1024;
  };

  system.stateVersion = "24.05";
}
