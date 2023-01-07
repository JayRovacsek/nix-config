{ self }:
let
  inherit (self.inputs.stable.lib) recursiveUpdate;
  inherit (self.outputs.nixosConfigurations) rpi1 rpi2;
  sd-configurtations = [ rpi1 rpi2 ];

  # Create a list of identifer to sdImage build derivations.
  built-derivations = builtins.map
    (builtins.mapAttrs (name: value: value.config.system.build.sdImage))
    sd-configurtations;

  # Fold list of image name => derivation into a set rather than a list
in builtins.foldl' recursiveUpdate { } built-derivations
