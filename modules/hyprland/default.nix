{ config, ... }:
let
  nvidiaPatches = builtins.any (driver: driver == "nvidia")
    config.services.xserver.videoDrivers;
in {
  programs.hyprland = {
    enable = true;
    inherit nvidiaPatches;
  };
}
