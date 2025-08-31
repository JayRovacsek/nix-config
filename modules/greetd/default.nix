{
  config,
  lib,
  pkgs,
  ...
}:
let
  hyperland-present = config.programs.hyprland.enable;
  # TODO: add other WM configurations where I might use them and greetd.
  # If utilised without hyprland the syntax of the default session will be
  # invalid
  cmd =
    if hyperland-present then
      "${config.programs.hyprland.package}/bin/Hyprland"
    else
      "";

  command = lib.concatStringsSep " " [
    "${pkgs.tuigreet}/bin/tuigreet"
    "--greeting"
    "'Welcome to NixOS!'"
    "--asterisks"
    "--remember"
    "--time"
    "--user-menu"
    "--cmd"
    cmd
  ];
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        inherit command;
        user = "greeter";
      };
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
