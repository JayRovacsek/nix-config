{ self }:
let
  inherit (self.common.home-manager-module-sets) ai desktop;
in
ai
++ desktop
++ (with self.homeManagerModules; [
  alacritty
  dbt
  dock
  home-manager-darwin
  utm
])
++ [
  {
    manual.manpages.enable = false;
  }
]
