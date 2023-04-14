{ self }:
let
  inherit (self.inputs) nixpkgs;
  inherit (self.common.system) unstable-system;
in unstable-system {
  system = "armv6l-linux";
  modules = [
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-raspberrypi.nix"
    {
      networking.hostName = "rpi1";
      nixpkgs = {
        config.allowUnsupportedSystem = true;
        crossSystem.system = "armv6l-linux";
      };
      system.stateVersion = "22.11";
    }
  ];
}
