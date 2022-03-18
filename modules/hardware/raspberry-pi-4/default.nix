{ config, pkgs, ... }: # Enable GPU acceleration
{
  hardware.raspberry-pi."4" = {
    fkms-3d.enable = true;
    audio.enable = true;
    dwc2.enable = true;
  };

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  boot.cleanTmpDir = true;

  boot = {
    extraModprobeConfig = ''
      options snd_bcm2835 enable_headphones=1
    '';
  };
}
