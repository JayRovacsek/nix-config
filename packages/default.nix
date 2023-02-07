{ self ? null, system ? null, pkgs ? null }:
let
  pkgs = if builtins.isNull self then
    import <nixpkgs> { }
  else
    self.inputs.stable.legacyPackages.${system};

  inherit (pkgs) callPackage;
  inherit (pkgs.lib) recursiveUpdate;

  packages = {
    amethyst = callPackage ./amethyst { };
    better-english = callPackage ./better-english { };
    velociraptor-bin = callPackage ./velociraptor-bin { };
    netextender = callPackage ./netextender { };
    trdsql-bin = callPackage ./trdsql-bin { };
    vulnix-pre-commit = callPackage ./vulnix-pre-commit { };
  };

  # Understand the context of where we're at - if in a flake then
  # merge the raspberry pi images in also to be a possible build option.
in if builtins.isNull self then
  packages
else
  recursiveUpdate self.outputs.common.images packages
