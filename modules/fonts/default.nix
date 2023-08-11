{ pkgs, lib, ... }:
let
  inherit (lib) version;
  inherit (pkgs.stdenv) isDarwin;

  hack-font = pkgs.nerdfonts.override { fonts = [ "Hack" ]; };

  fonts = (with pkgs; [ dejavu_fonts noto-fonts-emoji ]) ++ [ hack-font ];
  packages = fonts;

  # The fonts.font option changed in 23.11 - the below handles for this.
  # Darwin added as it seems currently still set to fonts.fonts in 
  # nix darwin possibly?
  settings = if (version > "23.11" && !isDarwin) then {
    inherit packages;
  } else {
    inherit fonts;
  };
in { fonts = { fontDir.enable = true; } // settings; }
