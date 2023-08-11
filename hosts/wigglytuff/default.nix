{ config, pkgs, lib, flake, ... }:

let
  inherit (flake) common;
  inherit (flake.common.home-manager-module-sets) base desktop-minimal;
  inherit (flake.lib) merge;

  builder = common.users.builder {
    inherit config pkgs;
    modules = base;
  };

  jay = common.users.jay {
    inherit config pkgs;
    modules = desktop-minimal;
  };

  merged = merge [ builder jay ];

in {
  inherit flake;
  inherit (merged) users home-manager;

  imports = [ ./hardware-configuration.nix ./modules.nix ./wireless.nix ];

  age.identityPaths =
    [ "/agenix/id-ed25519-ssh-primary" "/agenix/id-ed25519-wireless-primary" ];

  networking.hostName = "wigglytuff";
  networking.hostId = "d2a7b80b";
  system.stateVersion = "22.05";

  hardware = {
    deviceTree.filter = "bcm2711-rpi-4*.dtb";
    pulseaudio = {
      enable = true;
      # Default to the 3.5mm jack as output
      extraConfig = ''
        set-default-sink alsa_output.platform-bcm2835_audio.stereo-fallback.2
      '';
      package = pkgs.pulseaudioFull;
    };

    raspberry-pi."4" = {
      audio.enable = false;
      # Enable GPU acceleration
      fkms-3d = {
        enable = true;
        cma = 1024;
      };
      poe-hat.enable = false;
      pwm0.enable = false;
      tc358743.enable = false;
    };
  };

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" "vc4" ];

    extraModprobeConfig = ''
      options snd_bcm2835 enable_headphones=1
    '';
    kernelPackages = pkgs.linuxPackages_rpi4;
    kernelParams = [ "quiet" "console=tty3" "loglevel=0" "kunit.enable=0" ];
  };
}
