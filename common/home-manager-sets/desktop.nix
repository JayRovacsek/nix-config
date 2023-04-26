{ self }:
let
  inherit (self.common) home-manager-modules;
  inherit (self.common.home-manager-module-sets) cli;
in cli
++ (with home-manager-modules; [ alacritty desktop-packages firefox vscodium ])
