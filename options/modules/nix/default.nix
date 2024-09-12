{
  config,
  lib,
  ...
}:
with lib;
let
  merge = builtins.foldl' recursiveUpdate { };
  cfg = config.nix;

  # Submodule of source requires fields name and source,
  # and optionally enable if we have a reason to stop
  # the propagation of a select source
  source = {
    options = {
      # Assume true - opt in for false to explicitly disable a source
      enable = mkOption {
        default = true;
        type = with types; bool;
      };
      # Name should bind to the expected import <X> value
      name = mkOption { type = with types; str; };
      # Source should point to the source flake of X
      source = mkOption { type = with types; package; };
    };
  };

  sources-defined = (builtins.length cfg.sources) != 0;
in
{
  options = {
    nix.sources = mkOption {
      default = [ ];
      type = with types; listOf (submodule source);
    };
  };

  config = {
    # Create a value of environment.etc."nix/inputs.X" per source
    # Inherit the enable from code (default true)
    environment = mkIf sources-defined (
      merge (
        builtins.map (c: {
          etc."nix/inputs/${c.name}" = {
            inherit (c) enable source;
          };

        }) cfg.sources
      )
    );

    # Build a list of strings pointing to the above etc entries.
    # These need to exclude disabled values hence the filter
    nix.nixPath = mkIf sources-defined (
      lib.mkForce (
        builtins.map (c: "${c.name}=/etc/nix/inputs/${c.name}") (
          builtins.filter (c: c.enable) cfg.sources
        )
      )
    );
  };
}
