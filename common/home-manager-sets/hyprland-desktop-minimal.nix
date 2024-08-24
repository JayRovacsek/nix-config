{ self }:
let
  inherit (self.common.home-manager-module-sets) desktop;
in
desktop
++ (with self.homeManagerModules; [
  hyprland
  fuzzel
])
