{ stdenv, pkgs, lib, grim, slurp }:
with lib;
let
  name = "waybar-screenshot";
  pname = name;
  version = "0.0.1";
  meta = {
    description = "A simple shell wrapper for screenshotting via grim & slurp";
    # TODO: resolve intersect-multiple-lists issue
    inherit (grim.meta) platforms;
  };

  waybar-screenshot-wrapped = pkgs.writeShellScriptBin "waybar-screenshot" ''
    ${grim}/bin/grim -g "$(${slurp}/bin/slurp)"
  '';

  phases = [ "installPhase" "fixupPhase" ];

in stdenv.mkDerivation {
  inherit name pname version meta phases;

  buildInputs = [ waybar-screenshot-wrapped ];

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${waybar-screenshot-wrapped}/bin/waybar-screenshot $out/bin
  '';
}
