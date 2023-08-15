{ self }:
let
  inherit (self.common) home-manager-modules;
  inherit (self.common.home-manager-module-sets) desktop-minimal;
in desktop-minimal
++ (with home-manager-modules; [ alacritty discord firefox vscodium ])
