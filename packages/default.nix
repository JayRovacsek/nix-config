{ self, pkgs }:
let
  inherit (pkgs) lib system callPackage;
  inherit (lib) recursiveUpdate mapAttrs;
  inherit (self.inputs) terranix;
  inherit (self.common)
    terraform-stacks python-packages node-packages go-packages dotnet-packages
    resource-packages rust-packages images wallpaper-packages;

  # Fold an array of objects together recursively
  merge = builtins.foldl' recursiveUpdate { };

  dotnet = builtins.foldl' (accumulator: package:
    recursiveUpdate { ${package} = callPackage ./dotnet/${package} { }; }
    accumulator) { } dotnet-packages;

  go = builtins.foldl' (accumulator: package:
    recursiveUpdate { ${package} = callPackage ./go/${package} { }; }
    accumulator) { } go-packages;

  node = let inherit (pkgs) nodejs_20;
  in builtins.foldl' (accumulator: package:
    recursiveUpdate {
      ${package} = callPackage ./node/${package} { nodejs = nodejs_20; };
    } accumulator) { } node-packages;

  python = let
    python-overlay-pkgs = import self.inputs.nixpkgs {
      inherit system;
      overlays = [ self.overlays.python ];
    };
  in builtins.foldl' (accumulator: package:
    recursiveUpdate {
      ${package} = callPackage ./python/${package} {
        inherit self;
        pkgs = python-overlay-pkgs;
      };
    } accumulator) { } python-packages;

  resources = builtins.foldl' (accumulator: package:
    recursiveUpdate { ${package} = callPackage ./resources/${package} { }; }
    accumulator) { } resource-packages;

  rust = builtins.foldl' (accumulator: package:
    recursiveUpdate { ${package} = callPackage ./rust/${package} { }; }
    accumulator) { } rust-packages;

  terraform = mapAttrs (name: _:
    terranix.lib.terranixConfiguration {
      inherit system;
      modules = [
        { config._module.args = { inherit self system; }; }
        ../terranix/${name}
      ];
    }) terraform-stacks;

  wallpapers = builtins.foldl' (accumulator: package:
    recursiveUpdate { ${package} = callPackage ./wallpapers/${package} { }; }
    accumulator) { } wallpaper-packages;

  packages = merge [
    dotnet
    go
    images
    node
    python
    resources
    rust
    terraform
    wallpapers
    {
      better-english = callPackage ./better-english { };
      ditto-transform = callPackage ./ditto-transform { inherit self; };
      t2-firmware = callPackage ./t2-firmware { };
      vulnix-pre-commit = callPackage ./vulnix-pre-commit { };
      waybar-colour-picker = callPackage ./waybar-colour-picker { };
      waybar-screenshot = callPackage ./waybar-screenshot { };
      wofi-power = callPackage ./wofi-power { };
    }
  ];

in packages
