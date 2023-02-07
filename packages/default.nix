{ self ? null, system ? null, pkgs ? null }:
let
  pkgs = if builtins.isNull self then
    import <nixpkgs> { }
  else
    self.inputs.stable.legacyPackages.${system};

  inherit (pkgs) callPackage;
  inherit (pkgs.stdenv) isLinux isDarwin;
  inherit (pkgs.lib) recursiveUpdate;

  packages = {
    amethyst = if isDarwin then callPackage ./amethyst { } else { };
    better-english = callPackage ./better-english { };
    netextender = callPackage ./netextender { };
    trdsql-bin = callPackage ./trdsql-bin { };
    velociraptor-bin = callPackage ./velociraptor-bin { };
    vulnix-pre-commit = callPackage ./vulnix-pre-commit { };
  };

in if builtins.isNull self then
  packages
else
  recursiveUpdate self.outputs.common.images packages
