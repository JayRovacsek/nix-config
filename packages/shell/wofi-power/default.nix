{
  stdenv,
  pkgs,
  lib,
  wofi,
  gawk,
  systemd,
  hyprland,
  ...
}:
with lib;
let
  pname = "wofi-power";
  version = "0.0.1";

  meta = {
    description = "A simple shell wrapper for wofi to handle power events";
    # TODO: resolve intersect-multiple-lists issue
    inherit (wofi.meta) platforms;
  };

  wofi-power-wrapped = pkgs.writeShellScriptBin "wofi-power" ''
    entries="⇠ Logout\n⏾ Suspend\n⭮ Reboot\n⏻ Shutdown"

    selected=$(echo -e $entries | ${wofi}/bin/wofi --width 250 --height 210 --dmenu --cache-file /dev/null --insensitive | ${gawk}/bin/awk '{print tolower($2)}')

    case $selected in
      logout)
        ${hyprland}/bin/hyprctl dispatch exit;;
      suspend)
        ${systemd}/bin/systemctl suspend;;
      reboot)
        ${systemd}/bin/systemctl reboot;;
      shutdown)
        ${systemd}/bin/systemctl poweroff -i;;
    esac
  '';

  phases = [
    "installPhase"
    "fixupPhase"
  ];

in
stdenv.mkDerivation {
  inherit
    pname
    version
    meta
    phases
    ;

  buildInputs = [ wofi-power-wrapped ];

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${wofi-power-wrapped}/bin/wofi-power $out/bin
  '';
}
