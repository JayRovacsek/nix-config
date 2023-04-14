{ self }:
let
  inherit (self.lib) home-manager;
  inherit (self.common) package-sets;
in builtins.mapAttrs (_: pkgs: home-manager { inherit pkgs; }) package-sets
