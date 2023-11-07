{ stdenv, pkgs, lib, hyprpicker, wl-clipboard, ... }:
with lib;
let
  name = "waybar-colour-picker";
  pname = name;
  version = "0.0.1";
  meta = {
    description = "A simple shell wrapper hyprpicker";
    inherit (hyprpicker.meta) platforms;
  };

  waybar-colour-picker-wrapped =
    pkgs.writeShellScriptBin "waybar-colour-picker" ''
      ${hyprpicker}/bin/hyprpicker | ${wl-clipboard}/bin/wl-copy
    '';

  phases = [ "installPhase" "fixupPhase" ];

in stdenv.mkDerivation {
  inherit name pname version meta phases;

  buildInputs = [ waybar-colour-picker-wrapped ];

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${waybar-colour-picker-wrapped}/bin/waybar-colour-picker $out/bin
  '';
}
