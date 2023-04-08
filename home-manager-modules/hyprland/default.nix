{ osConfig, ... }:
let
  nvidiaPatches = builtins.any (driver: driver == "nvidia")
    osConfig.services.xserver.videoDrivers;
in {
  wayland.windowManager.hyprland = {
    enable = true;
    inherit nvidiaPatches;
    extraConfig = "";
  };
}
