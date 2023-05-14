{ pkgs }:
let inherit (pkgs) callPackage;
in {
  # Intentionally nesting here to avoid polluting the top level of packages with themes
  sddm-themes = { chili = callPackage ./chili { }; };
}
