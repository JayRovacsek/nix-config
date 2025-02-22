{ self }:
let
  inherit (self.common.home-manager-module-sets) desktop;
in
desktop
++ (with self.homeManagerModules; [
  alacritty
  utm
])
++ [
  {
    manual.manpages.enable = false;
  }
]
