{ pkgs, ... }:
let
  hack-font = pkgs.nerd-fonts.hack;
in
{
  fonts.packages =
    (with pkgs; [
      dejavu_fonts
      noto-fonts-emoji
    ])
    ++ [ hack-font ];
}
