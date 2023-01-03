{ self }:
let
  # The intention of this construct is to expose a flake-level generation of 
  # any number of packagesets to be consumed without boilerplate 
  inherit (self) inputs;
  inherit (inputs) nur;
  agenix = inputs.nur;

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

  inherit (inputs) microvm;

  inherit (self.outputs) exposedSystems;
  inherit (inputs.stable) lib;
  inherit (lib) recursiveUpdate;

  # TODO: cleanup the below big-time. Just short-handed it for speed

  overlays = [ nur.overlay agenix.overlay self.outputs.common.overlays ];

  microvmConfig = builtins.foldl' (acc: system:
    acc // (builtins.foldl'
      (y: z: y // { "${system}-${z.name}" = microvm.packages.${system}; }) { }
      targetGeneration)) { } (builtins.attrNames microvm.packages);

  # Done to make available the packageset identifier via the identifier attribute of
  # the packageset. Mostly everything else will be a derivation
  identifiers = builtins.foldl' (acc: system:
    acc // (builtins.foldl' (y: z:
      y // {
        "${system}-${z.name}" = { identifier = "${system}-${z.name}"; };
      }) { } targetGeneration)) { } exposedSystems;

  packageSets = builtins.foldl' (acc: system:
    acc // (builtins.foldl' (y: z:
      y // {
        "${system}-${z.name}" =
          import z.pkgs { inherit system overlays config; };
      }) { } targetGeneration)) { } exposedSystems;
in recursiveUpdate identifiers (recursiveUpdate microvmConfig packageSets)
