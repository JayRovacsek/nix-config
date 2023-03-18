{ self, system, pkgs }:
let
  pkgs = self.inputs.nixpkgs.legacyPackages.${system};
  inherit (pkgs) callPackage;
  inherit (pkgs.stdenv) isLinux isDarwin isx86_64;
  inherit (pkgs.lib) recursiveUpdate;
  inherit (pkgs.lib.attrsets) mapAttrs;
  inherit (self.inputs) terranix;
  inherit (self.common) terraform-stacks python-modules images;

  # Fold an array of objects together recursively
  merge = builtins.foldl' recursiveUpdate { };

  pythonModules = let inherit (pkgs) python310Packages python311Packages;
  in builtins.foldl' (accumulator: package:
    recursiveUpdate {
      python310Packages.${package} = callPackage ./python-modules/${package} {
        inherit self system;
        python = python310Packages;
      };
      python311Packages.${package} = callPackage ./python-modules/${package} {
        inherit self system;
        python = python311Packages;
      };
    } accumulator) { } python-modules;

  terraform-packages = mapAttrs (name: value:
    terranix.lib.terranixConfiguration {
      inherit system;
      modules = [
        { config._module.args = { inherit self system; }; }
        ../terranix/${name}
      ];
    }) terraform-stacks;

  packages = merge [
    images
    pythonModules
    terraform-packages
    {
      # Disable until I can resolve this
      # netextender = callPackage ./netextender { };
      amethyst = callPackage ./amethyst { };
      better-english = callPackage ./better-english { };
      ditto-transform = callPackage ./ditto-transform { inherit self; };
      plaso = callPackage ./plaso { inherit self system; };
      trdsql-bin = callPackage ./trdsql-bin { };
      velociraptor-bin = callPackage ./velociraptor-bin { };
      vulnix-pre-commit = callPackage ./vulnix-pre-commit { };
    }
  ];

in packages
