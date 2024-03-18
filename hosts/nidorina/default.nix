{ config, ... }: {
  imports = [ ./nginx.nix ];

  microvm = {
    interfaces = [{
      type = "macvtap";
      id = config.networking.hostName;
      mac = "02:42:c0:a8:05:03";
      macvtap = {
        link = "reverse-proxy";
        mode = "bridge";
      };
    }];

    mem = 1024;
  };

  networking.hostName = "nidorina";

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  system.stateVersion = "24.05";

  users.users.root.hashedPassword =
    "$y$j9T$1WjHbjaCPVGEEGwuozTF/1$m/0ChZOXjfB5jTB23JMz1HuoiTrH3aw.XRLhpGB6hR6";
}
