{ self }:
let
  inherit (self.common) home-manager-modules;
  inherit (self.common.home-manager-module-sets) desktop;
in desktop ++ (with home-manager-modules; [ ags hyprland fuzzel mako waybar ])
++ [ self.inputs.ags.homeManagerModules.default ]
