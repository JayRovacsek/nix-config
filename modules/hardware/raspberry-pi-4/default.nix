{ pkgs, ... }:
{
  boot = {
    extraModprobeConfig = ''
      options snd_bcm2835 enable_headphones=1
    '';
    initrd.availableKernelModules = [
      "usb_storage"
      "usbhid"
    ];

    kernelPackages = pkgs.linuxPackages_rpi4;

    # ttyAMA0 is the serial console broken out to the GPIO
    kernelParams = [
      "kunit.enable=0"
      "cma=128M"
      "console=tty1"
      "console=ttyAMA0,115200"
      "8250.nr_uarts=1"
    ];

    loader = {
      generic-extlinux-compatible.enable = true;
      grub.enable = false;
    };
  };

  hardware = {
    deviceTree.filter = "bcm2711-rpi-4*.dtb";

    # Required for the Wireless firmware
    enableRedistributableFirmware = true;

    raspberry-pi."4" = {
      # The below seem broken as of recent. See also: https://github.com/NixOS/nixos-hardware/issues/631
      # audio.enable = true;
      # Enable GPU acceleration
      # fkms-3d = {
      #   enable = true;
      #   cma = 1024;
      # };
      poe-hat.enable = false;
      pwm0.enable = false;
      tc358743.enable = false;
    };
  };

  services.pulseaudio = {
    enable = true;
    # Default to the 3.5mm jack as output
    extraConfig = ''
      set-default-sink alsa_output.platform-bcm2835_audio.stereo-fallback.2
    '';
    package = pkgs.pulseaudioFull;
  };
}
