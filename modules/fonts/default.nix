{ pkgs, ... }:
let
  hack-font = pkgs.nerdfonts.override { fonts = [ "Hack" ]; };
in
{
  fonts.packages =
    (with pkgs; [
      dejavu_fonts
      noto-fonts-emoji
    ])
    ++ [ hack-font ];
}
