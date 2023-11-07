{ stdenv, pkgs, lib, grim, slurp, wofi, wf-recorder, gawk, ... }:
with lib;
let
  name = "waybar-screenshot";
  pname = name;
  version = "0.0.1";
  meta = {
    description =
      "A simple shell wrapper for record via wf-recorder or screenshotting via grim & slurp";
    # TODO: resolve intersect-multiple-lists issue
    inherit (grim.meta) platforms;
  };

  waybar-screenshot-wrapped = pkgs.writeShellScriptBin "waybar-screenshot" ''
    entries="󰄀 Screenshot\n Record"

    selected=$(echo -e $entries | ${wofi}/bin/wofi --width 250 --height 210 --dmenu --cache-file /dev/null --insensitive | ${gawk}/bin/awk '{print tolower($2)}')

    case $selected in
      screenshot)
        ${grim}/bin/grim -g "$(${slurp}/bin/slurp)";;
      record)
        ${wf-recorder}/bin/wf-recorder -g "$(${slurp}/bin/slurp)";;
    esac
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
