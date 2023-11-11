{ self, pkgs }:
let
  inherit (pkgs) lib system callPackage;
  inherit (lib) recursiveUpdate mapAttrs;
  inherit (self.inputs) terranix;
  inherit (self.common)
    dotnet-packages images go-packages node-packages python-packages
    rust-packages shell-packages tofu-stacks wallpaper-packages;
  inherit (self.lib) merge;

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

  shell = builtins.foldl' (accumulator: package:
    recursiveUpdate {
      ${package} = callPackage ./shell/${package} { inherit self; };
    } accumulator) { } shell-packages;

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

  rust = builtins.foldl' (accumulator: package:
    recursiveUpdate { ${package} = callPackage ./rust/${package} { }; }
    accumulator) { } rust-packages;

  tofu = mapAttrs (name: _:
    terranix.lib.terranixConfiguration {
      inherit system;
      modules = [
        { config._module.args = { inherit self system; }; }
        ./terranix/${name}
      ];
    }) tofu-stacks;

  wallpapers = builtins.foldl' (accumulator: package:
    recursiveUpdate { ${package} = callPackage ./wallpapers/${package} { }; }
    accumulator) { } wallpaper-packages;

  packages = merge [
    dotnet
    go
    (builtins.removeAttrs images [ "configurations" ])
    node
    python
    rust
    shell
    tofu
    wallpapers
    {
      better-english = callPackage ./better-english { };
      t2-firmware = callPackage ./t2-firmware { };
    }
  ];

in packages
