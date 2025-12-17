{ pkgs, lib, ... }:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_hardened;

    loader = {
      grub = {
        device = "/dev/xvda";
        forceInstall = true;
        splashImage = lib.mkForce null;
      };
    };
  };

  networking = {
    interfaces.eth0.useDHCP = true;
    usePredictableInterfaceNames = false;
  };
}
