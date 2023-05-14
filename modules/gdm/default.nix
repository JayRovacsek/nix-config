{ config, ... }:
let
  wayland = config.programs.hyprland.enable;
  enable = true;
in {
  services.xserver = {
    inherit enable;
    displayManager.gdm = {
      inherit enable wayland;
      autoSuspend = true;
    };
  };
}
