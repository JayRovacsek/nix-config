{ self }:
let
  inherit (self.inputs) stable;

  inherit (self.common.system) stable-system;

in {
  rpi1 = stable-system {
    system = "armv6l-linux";
    modules = [
      "${stable}/nixos/modules/installer/sd-card/sd-image-raspberrypi.nix"
      {
        nixpkgs = {
          config.allowUnsupportedSystem = true;
          crossSystem.system = "armv6l-linux";
        };
        system.stateVersion = "22.11";
      }
    ];
  };
}
