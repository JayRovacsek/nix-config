{ self }:
let
  # The intention of this construct is to expose a flake-level generation of 
  # any number of packagesets to be consumed without boilerplate 
  inherit (self) inputs exposedSystems;
  # Inputs that expose overlays we require
  inherit (self.inputs) nur agenix-darwin microvm;
  # Required to fold sets together where shared keys exist
  inherit (inputs.stable.lib) recursiveUpdate;

  # We need to utilise the darwin-support fork of agenix until https://github.com/ryantm/agenix/pull/107 is reolved.
  agenix = agenix-darwin;

  # Wrap packagesets in a way that makes it a little more 
  # easy to utilise below
  stable = {
    pkgs = inputs.stable;
    name = "stable";
  };

  unstable = {
    pkgs = inputs.unstable;
    name = "unstable";
  };

  config = { allowUnfree = true; };

  targetGeneration = [ stable unstable ];

  # TODO: resolve default overlay before re-adding it
  # overlays = [ nur.overlay agenix.overlay self.overlays.default ];
  overlays = [ nur.overlay agenix.overlay ];

  # Create a set that includes the microvm packages where the upstream supports
  # it only, this'll mean we can avoid adding it explicitly to systems we want to use
  # it on, but not break stuff like darwin systems.
  microvmConfig = with builtins;
    foldl' (accumulator: system:
      accumulator // (foldl' (accumulator: target:
        accumulator // {
          "${system}-${target.name}" = microvm.packages.${system};
        }) { } targetGeneration)) { } (attrNames microvm.packages);

  # Done to make available the packageset identifier via the identifier attribute of
  # the packageset. Mostly everything else will be a derivation
  identifiers = builtins.foldl' (accumulator: system:
    accumulator // (builtins.foldl' (accumulator: target:
      accumulator // {
        "${system}-${target.name}" = {
          identifier = "${system}-${target.name}";
        };
      }) { } targetGeneration)) { } exposedSystems;

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
  packageSets = builtins.foldl' (accumulator: system:
    accumulator // (builtins.foldl' (accumulator: target:
      accumulator // {
        "${system}-${target.name}" =
          import target.pkgs { inherit system overlays config; };
      }) { } targetGeneration)) { } exposedSystems;
in recursiveUpdate identifiers (recursiveUpdate microvmConfig packageSets)
