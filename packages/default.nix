{ self, system, pkgs }:
let
  selfPkgs = self.outputs.packages.${system};
  inherit (pkgs) callPackage;
  inherit (pkgs.lib) recursiveUpdate;
  inherit (pkgs.lib.attrsets) mapAttrs;
  inherit (self.inputs) terranix;
  inherit (self.common)
    terraform-stacks python-packages node-packages go-packages dotnet-packages
    rust-packages images;

  # Fold an array of objects together recursively
  merge = builtins.foldl' recursiveUpdate { };

  dotnet = builtins.foldl' (accumulator: package:
    recursiveUpdate {
      dotnet-packages.${package} = callPackage ./dotnet-packages/${package} { };
    } accumulator) { } dotnet-packages;

  go = builtins.foldl' (accumulator: package:
    recursiveUpdate {
      go-packages.${package} = callPackage ./go-packages/${package} { };
    } accumulator) { } go-packages;

  node = let inherit (pkgs) nodejs_20;
  in builtins.foldl' (accumulator: package:
    recursiveUpdate {
      node-packages.${package} =
        callPackage ./node-packages/${package} { nodejs = nodejs_20; };
    } accumulator) { } node-packages;

  python =
    let inherit (pkgs) python39Packages python310Packages python311Packages;
    in builtins.foldl' (accumulator: package:
      recursiveUpdate {
        python39Packages.${package} = callPackage ./python-packages/${package} {
          python = python39Packages;
          ownPython = selfPkgs.python39Packages;
        };
        python310Packages.${package} =
          callPackage ./python-packages/${package} {
            python = python310Packages;
            ownPython = selfPkgs.python310Packages;
          };
        python311Packages.${package} =
          callPackage ./python-packages/${package} {
            python = python311Packages;
            ownPython = selfPkgs.python311Packages;
          };
      } accumulator) { } python-packages;

  rust = builtins.foldl' (accumulator: package:
    recursiveUpdate {
      rust-packages.${package} = callPackage ./rust-packages/${package} { };
    } accumulator) { } rust-packages;

  terraform = mapAttrs (name: _:
    terranix.lib.terranixConfiguration {
      inherit system;
      modules = [
        { config._module.args = { inherit self system; }; }
        ../terranix/${name}
      ];
    }) terraform-stacks;

  sddm-themes = import ./sddm-themes { inherit pkgs; };
  wallpapers = import ./wallpapers { inherit pkgs; };

  packages = merge [
    dotnet
    go
    images
    node
    python
    rust
    sddm-themes
    terraform
    wallpapers
    {
      better-english = callPackage ./better-english { };
      ditto-transform = callPackage ./ditto-transform { inherit self; };
      falcon-sensor = callPackage ./falcon-sensor { };
      t2-firmware = callPackage ./t2-firmware { };
      velociraptor-bin = callPackage ./velociraptor-bin { };
      vulnix-pre-commit = callPackage ./vulnix-pre-commit { };
      waybar-colour-picker = callPackage ./waybar-colour-picker { };
      waybar-screenshot = callPackage ./waybar-screenshot { };
      wofi-power = callPackage ./wofi-power { };
    }
  ];

in packages
