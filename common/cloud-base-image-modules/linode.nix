{ self }:
let inherit (self.inputs.nixpkgs) lib;
in {
  boot = {
    kernelParams = [ "console=ttyS0,19200n8" ];
    loader = {
      timeout = 10;
      grub = {
        device = "nodev";
        extraConfig = ''
          serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
          terminal_input serial;
          terminal_output serial
        '';
        forceInstall = true;
        splashImage = lib.mkForce null;
      };
    };
  };

  fileSystems."/" = {
    device = "/dev/sda";
    fsType = "ext4";
  };

  networking = {
    usePredictableInterfaceNames = false;
    interfaces.eth0.useDHCP = true;
  };

  swapDevices = [{ device = "/dev/sdb"; }];
}
