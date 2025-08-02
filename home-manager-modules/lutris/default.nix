{ osConfig, pkgs, ... }:
let
  inherit (pkgs) system;

  wayland-present = builtins.any (x: x) [
    osConfig.services.displayManager.gdm.wayland
    osConfig.programs.hyprland.enable
    osConfig.programs.xwayland.enable
  ];

  wine-wayland-compatible = builtins.elem system pkgs.wine-wayland.meta.platforms;

  use-wayland = wayland-present && wine-wayland-compatible;

in
{
  home.packages =
    with pkgs;
    [ lutris ]
    ++ (lib.optional use-wayland wine-wayland)
    ++ (lib.optional (!use-wayland) wine);
}
