{ self }:
let
  inherit (self.common.home-manager-module-sets) cli;
in
cli ++ (with self.homeManagerModules; [ desktop-packages ])
