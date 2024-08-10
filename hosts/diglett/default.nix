{
  lib,
  modulesPath,
  self,
  ...
}:
{
  imports =
    with self.nixosModules;
    [
      agenix
      disable-assertions
      nix-topology
      openvpn-server
      time
      timesyncd
    ]
    ++ [ "${modulesPath}/profiles/qemu-guest.nix" ];

  age.identityPaths = [ "/agenix/id-ed25519-diglett-primary" ];

  boot = {
    kernel.sysctl."vm.swappiness" = 5;
    kernelParams = [ "console=ttyS0,19200n8" ];
    loader = {
      grub = {
        device = "/dev/disk/by-label/nixos";
        extraConfig = ''
          serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
          terminal_input serial;
          terminal_output serial
        '';
        forceInstall = true;
        splashImage = lib.mkForce null;
      };
      systemd-boot.enable = false;
      timeout = 5;
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  swapDevices = [ { device = "/dev/disk/by-label/linode-swap"; } ];

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "yes";
        PasswordAuthentication = false;
      };
    };
  };

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };

    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = "nix-command flakes";
      http-connections = 0;
      sandbox = true;
      trusted-users = [ "@wheel" ];
    };
  };

  networking = {
    firewall.allowedTCPPorts = [ 22 ];
    hostName = "diglett";
    interfaces.eth0.useDHCP = true;
    usePredictableInterfaceNames = false;
  };

  system.stateVersion = "24.05";

  users.users.root.openssh.authorizedKeys.keys =
    self.common.networking.services.openssh.public-keys;
}
