{ config, ... }: {
  imports = [ ./authelia.nix ];

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

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  system.stateVersion = "24.05";

  users.users.root.hashedPassword =
    "$y$j9T$1WjHbjaCPVGEEGwuozTF/1$m/0ChZOXjfB5jTB23JMz1HuoiTrH3aw.XRLhpGB6hR6";
}
