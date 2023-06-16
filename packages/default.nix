{ self, system, pkgs }:
let
  selfPkgs = self.outputs.packages.${system};
  inherit (pkgs) callPackage;
  inherit (pkgs.lib) recursiveUpdate;
  inherit (pkgs.lib.attrsets) mapAttrs;
  inherit (self.inputs) terranix;
  inherit (self.common) terraform-stacks python-modules node-modules images;

  # Fold an array of objects together recursively
  merge = builtins.foldl' recursiveUpdate { };

  pythonModules =
    let inherit (pkgs) python39Packages python310Packages python311Packages;
    in builtins.foldl' (accumulator: package:
      recursiveUpdate {
        python39Packages.${package} = callPackage ./python-modules/${package} {
          python = python39Packages;
          ownPython = selfPkgs.python39Packages;
        };
        python310Packages.${package} = callPackage ./python-modules/${package} {
          python = python310Packages;
          ownPython = selfPkgs.python310Packages;
        };
        python311Packages.${package} = callPackage ./python-modules/${package} {
          python = python311Packages;
          ownPython = selfPkgs.python311Packages;
        };
      } accumulator) { } python-modules;

  nodeModules = let inherit (pkgs) nodejs_20;
  in builtins.foldl' (accumulator: package:
    recursiveUpdate {
      nodePackages.${package} =
        callPackage ./node-modules/${package} { nodejs = nodejs_20; };
    } accumulator) { } node-modules;

  terraform-packages = mapAttrs (name: _:
    terranix.lib.terranixConfiguration {
      inherit system;
      modules = [
        { config._module.args = { inherit self system; }; }
        ../terranix/${name}
      ];
    }) terraform-stacks;

  colour-schemes = import ./colour-schemes { inherit pkgs; };
  sddm-themes = import ./sddm-themes { inherit pkgs; };
  wallpapers = import ./wallpapers { inherit pkgs; };

  packages = merge [
    colour-schemes
    images
    nodeModules
    pythonModules
    sddm-themes
    terraform-packages
    wallpapers
    {
      better-english = callPackage ./better-english { };
      ditto-transform = callPackage ./ditto-transform { inherit self; };
      falcon-sensor = callPackage ./falcon-sensor { };
      pdscan-bin = callPackage ./pdscan-bin { };
      trdsql-bin = callPackage ./trdsql-bin { };
      velociraptor-bin = callPackage ./velociraptor-bin { };
      vulnix-pre-commit = callPackage ./vulnix-pre-commit { };
      waybar-colour-picker = callPackage ./waybar-colour-picker { };
      waybar-screenshot = callPackage ./waybar-screenshot { };
      wofi-power = callPackage ./wofi-power { };
    }
  ];

in packages
