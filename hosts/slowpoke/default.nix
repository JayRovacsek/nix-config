{ config, flake, ... }: {
  inherit flake;

  environment.noXlibs = false;

  networking.hostName = "slowpoke";

  microvm = {
    interfaces = [{
      type = "macvtap";
      id = config.networking.hostName;
      mac = "02:42:c0:a8:04:8a";
      macvtap = {
        link = "download";
        mode = "bridge";
      };
    }];
  };

  system.stateVersion = "24.05";
}
