{ config, self, ... }: {
  imports = with self.nixosModules; [
    agenix
    headscale
    microvm-guest
    time
    timesyncd
  ];

  networking.hostName = "magikarp";

  microvm = {
    interfaces = [{
      type = "macvtap";
      id = config.networking.hostName;
      mac = "02:42:c0:a8:19:02";
      macvtap = {
        link = "headscale";
        mode = "bridge";
      };
    }];
  };

  system.stateVersion = "24.05";
}
