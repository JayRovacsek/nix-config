{ lib, osConfig, pkgs, ... }:
let
  inherit (pkgs.stdenv) isLinux;
  wayland-present = isLinux && builtins.any (x: x) [
    osConfig.services.xserver.displayManager.gdm.wayland
    osConfig.programs.hyprland.enable
    osConfig.programs.xwayland.enable
  ];
in {
  home.packages =
    lib.optionals wayland-present (with pkgs; [ signal-desktop-wayland ])
    ++ lib.optionals (!wayland-present) (with pkgs; [ signal-desktop ]);
}
