{ self }:
let
  inherit (self.common) home-manager-modules;
  inherit (self.common.home-manager-module-sets) desktop;
  hyprlandHmModule = self.inputs.hyprland.homeManagerModules.default;
in desktop ++ (with home-manager-modules; [ hyprland ]) ++ [ hyprlandHmModule ]
