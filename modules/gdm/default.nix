{ config, ... }:
let wayland = config.programs.hyprland.enable;
in {
  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      inherit wayland;
      autoSuspend = true;
    };
  };
}
