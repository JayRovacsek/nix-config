{ config, flake, lib, ... }: {
  inherit flake;

  microvm = {
    interfaces = [{
      type = "macvtap";
      id = config.networking.hostName;
      mac = "02:42:c0:a8:06:08";
      macvtap = {
        link = "dns";
        mode = "bridge";
      };
    }];
  };

  networking = {
    dhcpcd.enable = false;
    hostName = "igglybuff";
    networkmanager.enable = false;
    useNetworkd = true;
  };

  # This is extremely important as this host does not utilise the
  # systemd networkd module, therefore not inheriting the
  # disabled resolved service.
  # 
  # Blocky doesn't like that punk resolvd taking 53 off them
  services.resolved.enable = false;

  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;
}
