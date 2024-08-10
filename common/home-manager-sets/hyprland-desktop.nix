{ self }:
let
  inherit (self.common.home-manager-module-sets) hyprland-desktop-minimal;
in
hyprland-desktop-minimal
++ (with self.homeManagerModules; [
  desktop-packages-extra
  swaync
])
