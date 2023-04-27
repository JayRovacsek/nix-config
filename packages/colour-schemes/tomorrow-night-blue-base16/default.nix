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
    base00 = "1d1f21";
    base01 = "ff9da4";
    base02 = "373b41";
    base03 = "d1f1a9";
    base04 = "bbdaff";
    base05 = "ebbbff";
    base06 = "e0e0e0";
    base07 = "ffffff";
    base08 = "cc6666";
    base09 = "de935f";
    base0A = "f0c674";
    base0B = "b5bd68";
    base0C = "8abeb7";
    base0D = "81a2be";
    base0E = "b294bb";
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
