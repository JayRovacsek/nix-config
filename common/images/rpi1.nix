{ self }:
let
  inherit (self.inputs) nixpkgs;
  inherit (self.common.system) unstable-system;
in unstable-system {
  system = "armv6l-linux";
  modules = [
    # "${nixpkgs}/nixos/modules/profiles/base.nix"
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image.nix"
    ({ config, lib, pkgs, ... }: {
      boot = {
        bcache.enable = false;

        consoleLogLevel = lib.mkDefault 7;

        enableContainers = false;

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

      documentation = {
        enable = false;
        doc.enable = false;
        info.enable = false;
        man.enable = false;
        nixos.enable = false;
      };

      fonts.fontconfig.enable = false;

      networking = {
        firewall.enable = false;
        hostName = "rpi1";
      };

      nixpkgs = {
        config.allowUnsupportedSystem = true;
        crossSystem = lib.systems.elaborate lib.systems.examples.raspberryPi;
        overlays = [ self.overlays.armv6l-fixes ];
      };

      programs = {
        nano.enable = false;
        less.enable = lib.mkDefault false;
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

      xdg = {
        icons.enable = false;
        mime.enable = false;
        sounds.enable = false;
      };
    })
  ];
}
