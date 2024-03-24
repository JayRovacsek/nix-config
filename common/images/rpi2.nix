{ self }:
let
  inherit (self.inputs) nixpkgs;
  inherit (self.common.system) unstable-system;
in unstable-system {
  system = "armv7l-linux";
  modules = [
    "${nixpkgs}/nixos/modules/profiles/base.nix"
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image.nix"
    ({ config, lib, pkgs, ... }: {
      boot = {
        consoleLogLevel = lib.mkDefault 7;
        # prevent `modprobe: FATAL: Module ahci not found`
        initrd.availableKernelModules = lib.mkForce [ "mmc_block" ];

        kernelPackages = lib.mkDefault pkgs.linuxPackages_rpi2;
        loader = {
          grub.enable = false;
          raspberryPi = {
            enable = true;
            version = 2;
            firmwareConfig = ''
              dtparam=i2c=on
            '';
          };
        };
      };

      networking.hostName = "rpi2";

      nixpkgs = {
        config.allowUnsupportedSystem = true;
        crossSystem =
          lib.systems.elaborate lib.systems.examples.armv7l-hf-multiplatform;
        overlays = [ self.overlays.armv7l-fixes ];
      };
      system.stateVersion = "24.05";

      sdImage = {
        imageBaseName = "nixos-raspberry-pi-2";
        populateRootCommands = "";
        populateFirmwareCommands = with config.system.build; ''
          ${installBootLoader} ${toplevel} -d ./firmware
        '';
        firmwareSize = 64;
      };
    })
  ];
}
