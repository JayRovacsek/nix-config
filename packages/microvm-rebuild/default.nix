{ stdenv, pkgs, lib }:
with lib;
let
  name = "microvm-rebuild";
  pname = "microvm-rebuild";
  version = "0.0.1";
  meta = {
    description =
      "A simple shell wrapper to make rebuilding of microvms easier";
    platforms = platforms.unix;
  };

  microvm-rebuild-wrapped = pkgs.writeShellScriptBin "microvm-rebuild" ''
    echo "One day I'll get back to this..."
  '';

  phases = [ "installPhase" "fixupPhase" ];

in stdenv.mkDerivation {
  inherit name pname version meta phases;

  buildInputs = [ microvm-rebuild-wrapped ];

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${microvm-rebuild-wrapped}/bin/microvm-rebuild $out/bin
  '';
}
