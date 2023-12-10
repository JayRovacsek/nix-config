{ self }:
let
  inherit (self.inputs) nixpkgs;
  inherit (self.common.system) unstable-system;
in unstable-system {
  system = "armv6l-linux";
  modules = [
    "${nixpkgs}/nixos/modules/profiles/base.nix"
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image.nix"
    ({ config, lib, pkgs, ... }: {
      boot = {
        consoleLogLevel = lib.mkDefault 7;

        # prevent `modprobe: FATAL: Module ahci not found`
        initrd.availableKernelModules = pkgs.lib.mkForce [ "mmc_block" ];

        kernelPackages = lib.mkDefault pkgs.linuxPackages_rpi1;

        loader = {
          grub.enable = false;
          raspberryPi = {
            enable = true;
            version = 1;
            firmwareConfig = ''
              dtparam=i2c=on
            '';
          };
        };
      };

      networking.hostName = "rpi1";

      nixpkgs = {
        config.allowUnsupportedSystem = true;
        crossSystem = lib.systems.elaborate lib.systems.examples.raspberryPi;
        overlays = [ self.overlays.diffutils self.overlays.gnugrep-no-check ];
      };
      system.stateVersion = "24.05";

      sdImage = {
        imageBaseName = "nixos-raspberry-pi-1";
        populateRootCommands = "";
        populateFirmwareCommands = with config.system.build; ''
          ${installBootLoader} ${toplevel} -d ./firmware
        '';
        firmwareSize = 64;
      };
    })
  ];
}
