{ config, flake, ... }: {
  inherit flake;

  networking.hostName = "meowth";

  microvm = {
    interfaces = [{
      type = "macvtap";
      id = config.networking.hostName;
      mac = "02:42:c0:a8:04:89";
      macvtap = {
        link = "download";
        mode = "bridge";
      };
    }];
  };

  system.stateVersion = "24.05";
}
