{ self }:
let
  inherit (self.inputs) stable nixos-hardware;
  inherit (self.common.system) stable-system;

in stable-system {
  system = "armv7l-linux";
  modules = [
    nixos-hardware.nixosModules.raspberry-pi-2
    "${stable}/nixos/modules/installer/sd-card/sd-image-raspberrypi.nix"
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
