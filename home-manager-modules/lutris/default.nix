{ osConfig, pkgs, ... }:
let
  inherit (pkgs) system;

  wayland-present = builtins.any (x: x) [
    osConfig.services.xserver.displayManager.gdm.wayland
    osConfig.programs.hyprland.enable
    osConfig.programs.xwayland.enable
  ];

  wine-wayland-compatible =
    builtins.elem system pkgs.wine-wayland.meta.platforms;

  lutris =
    if (builtins.all (x: x) [ wayland-present wine-wayland-compatible ]) then
      pkgs.lutris.override {
        extraPkgs = _pkgs:
          [ (lutris.override { extraPkgs = pkgs: [ pkgs.wine-wayland ]; }) ];
      }
    else
      pkgs.lutris;

in { home.packages = [ lutris ]; }
