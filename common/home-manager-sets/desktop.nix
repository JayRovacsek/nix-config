{ self }:
let
  inherit (self.common.home-manager-module-sets) desktop-minimal;
in
desktop-minimal
++ (with self.homeManagerModules; [
  discord
  firefox
  ghostty
  keepassxc
  nextcloud-client
  slack
  thunderbird
  vscodium
])
