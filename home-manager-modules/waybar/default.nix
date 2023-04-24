{ pkgs, osConfig, ... }:
let
  inherit (osConfig) flake;
  inherit (flake) lib;
  style = lib.toCss (import ./style.nix);
  settings = import ./settings.nix { inherit pkgs osConfig; };
  package =
    osConfig.flake.inputs.hyprland.packages.x86_64-linux.waybar-hyprland;
in {
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
    inherit style settings package;
  };
}
