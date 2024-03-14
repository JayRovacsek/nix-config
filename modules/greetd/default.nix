{ config, lib, pkgs, ... }:
let
  hyperland-present = config.programs.hyprland.enable;
  # TODO: add other WM configurations where I might use them and greetd.
  # If utilised without hyprland the syntax of the default session will be 
  # invalid
  cmd = if hyperland-present then "${pkgs.hyprland}/bin/Hyprland" else "";

  command = lib.concatStringsSep " " [
    "${pkgs.greetd.tuigreet}/bin/tuigreet"
    "--greeting"
    "'Welcome to NixOS!'"
    "--asterisks"
    "--remember-session"
    "--time"
    "--user-menu"
    "--cmd"
    cmd
  ];
in {
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
