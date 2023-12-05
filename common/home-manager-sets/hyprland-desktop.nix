{ self }:
let
  inherit (self.common) home-manager-modules;
  inherit (self.common.home-manager-module-sets) hyprland-desktop-minimal;
in hyprland-desktop-minimal
++ (with home-manager-modules; [ desktop-packages-extra ])
