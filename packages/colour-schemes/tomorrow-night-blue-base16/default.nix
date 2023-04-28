{ stdenv, lib, writeText }:
with lib;
let
  name = "tomorrow-night-blue-base16";
  pname = name;
  version = "0.0.1";
  meta = {
    description = "Soothing pastel theme for base16 (WIP)";
    platforms = platforms.all;
    homepage = "https://github.com/chriskempson/tomorrow-theme";
    license = licenses.mit;
  };

  theme = generators.toYAML { } {
    # Black
    base00 = "1d1f21";
    # Pink
    base01 = "ff9da4";
    # Dark Green/Blue
    base02 = "373b41";
    # Light Green
    base03 = "d1f1a9";
    # Light Blue
    base04 = "bbdaff";
    # Lavender
    base05 = "ebbbff";
    # Grey
    base06 = "e0e0e0";
    # White
    base07 = "ffffff";
    # Dark Pink/Red
    base08 = "cc6666";
    # Orange
    base09 = "de935f";
    # Light Orange
    base0A = "f0c674";
    # Dark Green
    base0B = "b5bd68";
    # Dark Aqua
    base0C = "8abeb7";
    # Blue
    base0D = "81a2be";
    # Dark Lavendar
    base0E = "b294bb";
    # Brown
    base0F = "a3685a";
  };

  content = writeText "out.yaml" theme;

  phases = [ "installPhase" "fixupPhase" ];

in stdenv.mkDerivation {
  inherit name pname version meta phases;

  installPhase = ''
    mkdir -p $out/share/themes
    ln -s ${content} $out/share/themes/tomorrow-night-blue.yaml
  '';
}
