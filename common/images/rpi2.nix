{ self }:
let
  inherit (self.inputs) nixpkgs;
  inherit (self.common.system) unstable-system;
in unstable-system {
  system = "armv7l-linux";
  modules = [
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-raspberrypi.nix"
    {
      networking.hostName = "rpi2";
      nixpkgs = {
        config.allowUnsupportedSystem = true;
        crossSystem.system = "armv7l-linux";
      };
      system.stateVersion = "22.11";
    }
  ];
}
