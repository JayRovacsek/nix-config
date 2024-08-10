{ pkgs, config, ... }:
let
  lockCmd = "${config.programs.hyprlock.package}/bin/hyprlock";
  hyprctl = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl";
in {
  services.hypridle = {
    enable = true;

    settings = {
      beforeSleepCmd = "${pkgs.systemd}/bin/loginctl lock-session";

      listener = [
        {
          timeout = 300;
          onTimeout = lockCmd;
        }
        {
          timeout = 600;
          onTimeout = "${hyprctl} dispatch dpms off";
          onResume = "${hyprctl} dispatch dpms on";
        }
      ];

      inherit lockCmd;
    };
  };
}
