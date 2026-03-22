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
  utm
])
++ [
  {
    manual.manpages.enable = false;
  }
]
