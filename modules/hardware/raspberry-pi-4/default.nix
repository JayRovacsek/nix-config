{ pkgs, ... }: {
  hardware = {
    deviceTree.filter = "bcm2711-rpi-*.dtb";

    # Required for the Wireless firmware
    enableRedistributableFirmware = true;

    pulseaudio = {
      enable = true;
      # Default to the 3.5mm jack as output
      extraConfig = ''
        set-default-sink alsa_output.platform-bcm2835_audio.stereo-fallback.2
      '';
      package = pkgs.pulseaudioFull;
    };

    raspberry-pi."4" = {
      audio.enable = true;
      dwc2.enable = false;
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
    extraModprobeConfig = ''
      options snd_bcm2835 enable_headphones=1
    '';
    initrd.availableKernelModules = [ "usb_storage" "usbhid" ];

    kernelPackages = pkgs.linuxPackages_rpi4;

    # ttyAMA0 is the serial console broken out to the GPIO
    kernelParams =
      [ "cma=128M" "console=tty1" "console=ttyAMA0,115200" "8250.nr_uarts=1" ];

    loader = {
      generic-extlinux-compatible.enable = true;
      grub.enable = false;
    };

    tmp = {
      cleanOnBoot = true;
      useTmpfs = true;
    };
  };
}
