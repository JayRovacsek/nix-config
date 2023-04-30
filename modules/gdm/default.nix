{ config, ... }:
let wayland = config.programs.hyprland.enable;
in {
  services.xserver.displayManager.gdm = {
    enable = true;
    inherit wayland;
    autoSuspend = true;
  };
}
