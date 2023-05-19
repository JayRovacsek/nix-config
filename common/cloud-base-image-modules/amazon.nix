{ self }:
let
  inherit (self.inputs.nixpkgs) lib;
  pkgs = self.inputs.nixpkgs.legacyPackages.x86_64-linux;
in {
  boot.kernelPackages = pkgs.linuxPackages_6_1_hardened;

  boot.loader.grub.forceInstall = true;
  boot.loader.grub = {
    device = "/dev/xvda";
    splashImage = lib.mkForce null;
  };

  networking.usePredictableInterfaceNames = false;
  networking.interfaces.eth0.useDHCP = true;
}
