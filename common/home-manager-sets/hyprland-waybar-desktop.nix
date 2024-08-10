{ self }:
let
  inherit (self.common.home-manager-module-sets) hyprland-desktop;
in
hyprland-desktop
++ (with self.homeManagerModules; [
  mako
  waybar
])
