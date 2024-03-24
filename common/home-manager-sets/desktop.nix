{ self }:
let inherit (self.common.home-manager-module-sets) desktop-minimal;
in desktop-minimal ++ (with self.homeManagerModules; [
  alacritty
  discord
  firefox
  keepassxc
  slack
  vscodium
])
