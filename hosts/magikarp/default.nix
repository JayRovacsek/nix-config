{ config, flake, ... }: {
  inherit flake;

  networking.hostName = "magikarp";

  users.users.root.hashedPassword =
    "$y$j9T$1WjHbjaCPVGEEGwuozTF/1$m/0ChZOXjfB5jTB23JMz1HuoiTrH3aw.XRLhpGB6hR6";

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  networking.firewall.allowedTCPPorts = [ 22 ];

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

    mem = 1024;
  };

  system.stateVersion = "24.05";
}