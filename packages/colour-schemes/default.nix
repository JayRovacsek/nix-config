{ pkgs }:
let inherit (pkgs) callPackage;
in {
  # Intentionally nesting here to avoid polluting the top level of packages with wallpapers
  colour-schemes = {
    catppuccin-base16 = callPackage ./catppuccin-base16 { };
    tomorrow-night-blue-base16 = callPackage ./tomorrow-night-blue-base16 { };
  };
}
