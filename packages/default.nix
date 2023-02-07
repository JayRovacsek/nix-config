{ self ? null, system ? null, pkgs ? import <nixpkgs> { } }:
let
  pkgs = if builtins.isNull self then
    pkgs
  else
    self.inputs.stable.legacyPackages.${system};

  inherit (pkgs) callPackage;
  inherit (pkgs.lib) recursiveUpdate;

  packages = {
    amethyst = callPackage ./amethyst { };
    better-english = callPackage ./better-english { };
    netextender = callPackage ./netextender { };
    velociraptor-bin = callPackage ./velociraptor-bin { };
    vulnix-pre-commit = callPackage ./vulnix-pre-commit { };
  };

in if builtins.isNull self then
  packages
else
  recursiveUpdate self.outputs.common.images packages
