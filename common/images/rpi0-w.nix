{ self }:
let
  inherit (self.inputs) nixpkgs;
  inherit (self.common.system) unstable-system;
in
unstable-system {
  system = "armv6l-linux";
  modules = [
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-raspberrypi.nix"
    (
      { config, ... }:
      {
        networking.hostName = "rpi0w";
        nixpkgs = {
          config.allowUnsupportedSystem = true;
          crossSystem.system = "armv6l-linux";
        };

        sdImage = {
          imageBaseName = "nixos-raspberry-pi-zero-w";
          populateRootCommands = "";
          populateFirmwareCommands = with config.system.build; ''
            ${installBootLoader} ${toplevel} -d ./firmware
          '';
          firmwareSize = 64;
        };

        system.stateVersion = "24.05";
      }
    )
  ];
}
