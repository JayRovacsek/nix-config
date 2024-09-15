{ self, pkgs }:
let
  inherit (pkgs) lib system callPackage;
  inherit (lib) recursiveUpdate mapAttrs;
  inherit (self.inputs) terranix;
  inherit (self.common)
    dotnet-packages
    images
    go-packages
    node-packages
    python-packages
    resource-packages
    rust-packages
    shell-packages
    text-packages
    tofu-stacks
    ;
  inherit (self.lib) merge;

  dotnet = builtins.foldl' (
    accumulator: package:
    recursiveUpdate {
      ${package} = callPackage ./dotnet/${package} { };
    } accumulator
  ) { } dotnet-packages;

  go = builtins.foldl' (
    accumulator: package:
    recursiveUpdate { ${package} = callPackage ./go/${package} { }; } accumulator
  ) { } go-packages;

  node =
    let
      inherit (pkgs) nodejs_20;
    in
    builtins.foldl' (
      accumulator: package:
      recursiveUpdate {
        ${package} = callPackage ./node/${package} { nodejs = nodejs_20; };
      } accumulator
    ) { } node-packages;

  other = builtins.foldl' (
    accumulator: package:
    recursiveUpdate { ${package} = callPackage ./other/${package} { }; } accumulator
  ) { } (builtins.attrNames (builtins.readDir ./other));

  python = builtins.foldl' (
    accumulator: package:
    recursiveUpdate {
      ${package} = callPackage ./python/${package} {
        inherit self;
        inherit pkgs;
      };
    } accumulator
  ) { } python-packages;

  rust = builtins.foldl' (
    accumulator: package:
    recursiveUpdate { ${package} = callPackage ./rust/${package} { }; } accumulator
  ) { } rust-packages;

  shell = builtins.foldl' (
    accumulator: package:
    recursiveUpdate {
      ${package} = callPackage ./shell/${package} { inherit self; };
    } accumulator
  ) { } shell-packages;

  text = builtins.foldl' (
    accumulator: package:
    recursiveUpdate {
      ${package} = callPackage ./text/${package} { inherit self; };
    } accumulator
  ) { } text-packages;

  tofu = mapAttrs (
    name: _:
    terranix.lib.terranixConfiguration {
      inherit system;
      modules = [
        {
          config._module.args = {
            inherit self system;
          };
        }
        ./terranix/${name}
      ];
    }
  ) tofu-stacks;

  resources = builtins.foldl' (
    accumulator: package:
    recursiveUpdate {
      ${package} = callPackage ./resources/${package} { };
    } accumulator
  ) { } resource-packages;

  packages = merge [
    dotnet
    go
    (builtins.removeAttrs images [ "configurations" ])
    node
    other
    python
    resources
    rust
    shell
    text
    tofu
    { inherit (self.inputs.disko.packages.${system}) disko disko-install; }
  ];

in
packages
