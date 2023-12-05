{ self }:
let
  inherit (self.common) home-manager-modules;
  inherit (self.common.home-manager-module-sets) hyprland-desktop;
in hyprland-desktop ++ (with home-manager-modules; [ mako waybar ])
