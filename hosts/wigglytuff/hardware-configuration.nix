{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  hardware.enableRedistributableFirmware = true;
  swapDevices = [{
    device = "/swapfile";
    size = 3072;
  }];

  hardware.pulseaudio.extraConfig = ''
    set-default-sink alsa_output.platform-bcm2835_audio.stereo-fallback.2
  '';
}
