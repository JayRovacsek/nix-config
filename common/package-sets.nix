{ self }:
let
  # The intention of this construct is to expose a flake-level generation of 
  # any number of packagesets to be consumed without boilerplate 
  inherit (self) inputs;
  # Inputs that expose overlays we require
  inherit (self.inputs) flake-utils;
  inherit (self.common.overlays) darwin linux system-agnostic;
  # Required to fold sets together where shared keys exist
  inherit (inputs.stable.lib) recursiveUpdate;

  # Wrap packagesets in a way that makes it a little more 
  # easy to utilise below
  stable = {
    pkgs = inputs.stable;
    name = "stable";
  };

  unstable = {
    pkgs = inputs.nixpkgs;
    name = "unstable";
  };

  bleeding-edge = {
    pkgs = inputs.bleeding-edge;
    name = "bleeding-edge";
  };

  config.allowUnfree = true;

  targetGeneration = [
    stable
    unstable
    bleeding-edge
  ];

  # Done to make available the packageset identifier via the identifier attribute of
  # the packageset. Mostly everything else will be a derivation
  identifiers = builtins.foldl' (
    accumulator: system:
    accumulator
    // (builtins.foldl' (
      accumulator: target:
      accumulator
      // {
        "${system}-${target.name}" = {
          identifier = "${system}-${target.name}";
        };
      }
    ) { } targetGeneration)
  ) { } flake-utils.lib.defaultSystems;

  # Take both of the above and then merge them plus the load of nixpkgs for
  # the input.
  #
  # Effectively the end product should expose via repl:
  #
  # nix-repl> common.package-sets
  # aarch64-darwin-stable = { ... }; 
  # aarch64-darwin-unstable = { ... }; 
  # aarch64-linux-stable = { ... }; 
  # aarch64-linux-unstable = { ... }; 
  # x86_64-darwin-stable = { ... }; 
  # x86_64-darwin-unstable = { ... }; 
  # x86_64-linux-stable = { ... }; 
  # x86_64-linux-unstable = { ... };
  #
  # Each will add the "identifier" property to the set to avoid need of 
  # further hacks to understand from a system perspective what has been applied to
  # it.
  #
  # nix-repl> common.package-sets.aarch64-darwin-stable.identifier
  # "aarch64-darwin-stable"
  #
  packageSets = builtins.foldl' (
    accumulator: system:
    accumulator
    // (builtins.foldl' (
      accumulator: target:
      accumulator
      // {
        "${system}-${target.name}" =
          let
            pkgs = target.pkgs.legacyPackages.${system};
            inherit (pkgs.stdenv) isDarwin isLinux;
            inherit (pkgs.lib.lists) optionals;
          in
          import target.pkgs {
            inherit system config;
            # Hack is required to contextually add overlays based.
            # This might be better abstracted into a set that then is
            # pulled via getAttr, but that'll be a next refactor step
            # rather than MVP suitable.
            overlays =
              system-agnostic ++ (optionals isDarwin darwin) ++ (optionals isLinux linux);
          };
      }
    ) { } targetGeneration)
  ) { } flake-utils.lib.defaultSystems;
in
recursiveUpdate identifiers packageSets
