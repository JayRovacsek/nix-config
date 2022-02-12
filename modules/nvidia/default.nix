{
  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
    nvidia = { modesetting.enable = true; };
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}
