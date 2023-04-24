{ pkgs }:
let inherit (pkgs) callPackage;
in {
  # Intentionally nesting here to avoid polluting the top level of packages with wallpapers
  wallpapers = {
    may-sitting-near-waterfall-pokemon-emerald =
      callPackage ./may-sitting-near-waterfall-pokemon-emerald { };

    sunset-over-river-in-the-evening =
      callPackage ./sunset-over-river-in-the-evening { };
  };
}
