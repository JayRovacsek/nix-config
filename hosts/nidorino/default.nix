{ config, self, ... }: {
  imports = with self.nixosModules; [
    ./authelia.nix
    agenix
    authelia
    microvm-guest
    nginx
    time
    timesyncd
  ];

  microvm = {
    interfaces = [{
      type = "macvtap";
      id = config.networking.hostName;
      mac = "02:42:c0:a8:09:02";
      macvtap = {
        link = "authelia";
        mode = "bridge";
      };
    }];

    mem = 1024;
    vcpu = 2;
  };

  networking.hostName = "nidorino";

  system.stateVersion = "24.05";
}
