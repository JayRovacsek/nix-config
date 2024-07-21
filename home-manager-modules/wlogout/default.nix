{ config, pkgs, ... }:
let
  elements = [
    {
      "label" = "lock";
      "action" = "${config.programs.hyprlock.package}/bin/hyprlock";
      "text" = "Lock";
    }
    {
      "label" = "hibernate";
      "action" = "${pkgs.systemd}/bin/systemctl hibernate";
      "text" = "Hibernate";
    }
    {
      "label" = "reboot";
      "action" = "${pkgs.systemd}/bin/systemctl reboot";
      "text" = "Reboot";
    }
    {
      "label" = "shutdown";
      "action" = "${pkgs.systemd}/bin/systemctl poweroff";
      "text" = "Shutdown";
    }
    {
      "label" = "logout";
      "action" = "${pkgs.systemd}/bin/loginctl terminate-user $USER";
      "text" = "Logout";
    }
    {
      "label" = "suspend";
      "action" = "${pkgs.systemd}/bin/systemctl suspend";
      "text" = "Suspend";
    }
  ];
in {
  home.file."${config.xdg.configHome}/wlogout/layout".text =
    builtins.concatStringsSep "\n"
    (builtins.map (e: builtins.toJSON e) elements);
}
