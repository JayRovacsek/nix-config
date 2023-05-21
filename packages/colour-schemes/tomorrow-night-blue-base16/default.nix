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
    base00 = "002451";
    base01 = "001733";
    base02 = "003f8e";
    base03 = "7285b7";
    base04 = "949494";
    base05 = "ffffff";
    base06 = "e0e0e0";
    base07 = "ffffff";
    base08 = "a92049";
    base09 = "ff9da4";
    base0A = "ffeead";
    base0B = "d1f1a9";
    base0C = "ffffff";
    base0D = "ffc58f";
    base0E = "d778ff";
    base0F = "cd9731";
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
