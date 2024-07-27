_: {
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia.modesetting.enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}
