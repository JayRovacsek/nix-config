{ self ? null, system ? null, pkgs ? import <nixpkgs> { } }:
let
  pkgs = if builtins.isNull self then
    pkgs
  else
    self.inputs.stable.legacyPackages.${system};

  inherit (pkgs) callPackage;
  inherit (pkgs.lib) recursiveUpdate;

in recursiveUpdate self.outputs.common.images {
  amethyst = callPackage ./amethyst { };
  better-english = callPackage ./better-english { };
  pokemmo-installer = callPackage ./pokemmo { };
}
