{ config, lib, ... }:
let patchDriver = import ./nvenc-unlock.nix;
in {
  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
    nvidia = {
      package = patchDriver config.boot.kernelPackages.nvidiaPackages.stable;
      modesetting.enable = true;
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}
