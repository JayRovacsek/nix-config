{ self }:
let
  inherit (self.inputs) gbar;
  inherit (self.common) home-manager-modules;
  inherit (self.common.home-manager-module-sets) desktop;
in desktop ++ (with home-manager-modules; [ hyprland fuzzel mako waybar ])
++ [ gbar.homeManagerModules.x86_64-linux.default ]
