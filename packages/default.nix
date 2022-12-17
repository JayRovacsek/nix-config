{ pkgs }:
let inherit (pkgs.stdenv) isDarwin;
in with pkgs; {
  amethyst = if isDarwin then callPackage ./amethyst { } else { };
  pokemmo-installer = callPackage ./pokemmo { };
}
