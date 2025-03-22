{ config, ... }:
{
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      open = true;
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.production;
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}
