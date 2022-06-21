{ config, pkgs, ... }: # Enable GPU acceleration
{
  hardware.raspberry-pi."4" = {
    fkms-3d = {
      enable = true;
      cma = 1024;
    };
    audio.enable = true;
    dwc2.enable = false;
    poe-hat.enable = false;
    pwm0.enable = false;
    tc358743.enable = false;
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
