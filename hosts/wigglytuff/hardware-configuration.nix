{ pkgs, ... }: {
  boot = {
    # VC4 required for GPU hardware acceleration
    initrd.availableKernelModules = [
      "pcie_brcmstb"
      "reset-raspberrypi"
      "usb_storage"
      "usbhid"
      "vc4"
      "xhci_pci"
    ];

    # Set the headphone jack as the default output
    extraModprobeConfig = ''
      options snd_bcm2835 enable_headphones=1
    '';

    kernelPackages = pkgs.linuxPackages_rpi4;
    kernelParams = [
      "cma=256M"
      "console=tty1"
      "console=ttyAMA0,115200"
      "8250.nr_uarts=1"
      "kunit.enable=0"
    ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  hardware = {
    # Filter for just pi4 replated device drivers
    deviceTree.filter = "bcm2711-rpi-4*.dtb";

    # Audio settings to ensure the headphones are the default
    pulseaudio = {
      enable = true;
      # Default to the 3.5mm jack as output
      extraConfig = ''
        set-default-sink alsa_output.platform-bcm2835_audio.stereo-fallback.2
      '';
      package = pkgs.pulseaudioFull;
    };

    raspberry-pi."4" = {
      # Enable GPU acceleration
      fkms-3d = {
        enable = true;
        cma = 1024;
      };
    };
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  # Create a swapfile as config
  swapDevices = [{
    device = "/swapfile";
    size = 3072;
  }];
}
