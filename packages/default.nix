{ self, pkgs }:
let
  inherit (pkgs) lib system callPackage;
  inherit (lib) recursiveUpdate mapAttrs;
  inherit (self.inputs) terranix;
  inherit (self.common)
    c-packages cpp-packages dotnet-packages images go-packages node-packages
    python-packages rust-packages shell-packages tofu-stacks wallpaper-packages;
  inherit (self.lib) merge;

  c = builtins.foldl' (accumulator: package:
    recursiveUpdate { ${package} = callPackage ./c/${package} { }; }
    accumulator) { } c-packages;

  cpp = builtins.foldl' (accumulator: package:
    recursiveUpdate { ${package} = callPackage ./cpp/${package} { }; }
    accumulator) { } cpp-packages;

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

  # Python packages that require upstream packages to have changes made
  # as could be done via an overlay are intentionally not done
  # via an overlay to avoid a messy instance where some python overlays
  # need to be consumed, but not all. This could be worked around if
  # needed, but allows us to remove a lot of code from our overlays 
  # definitions for now.
  python = let
    # For all upstream python3Packages versions, build a dedicated
    # version of this package.
    python-package-versions =
      builtins.filter (x: (builtins.match "python3[0-9]{1,2}Packages" x) == [ ])
      (builtins.attrNames pkgs);
    # For each upstream python3Packages version, generate a set of 
    # derivations that align with upstream version.
  in lib.genAttrs python-package-versions (version:
    builtins.foldl' (accumulator: package:
      recursiveUpdate {
        ${package} = callPackage ./python/${package} {
          inherit pkgs self;
          # Pass the python3Packages version explicitly 
          # so we can ensure the correct version is utilised
          # Note downstream we need to reflect on the version of
          # python passed to then consume dependencies that may only
          # be defined in this flake (such as dfvfs)
          python3Packages = pkgs.${version};
        };
      } accumulator) { } python-packages);

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
    c
    cpp
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
