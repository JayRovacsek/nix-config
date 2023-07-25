{ pkgs, ... }:
let hack-font = pkgs.nerdfonts.override { fonts = [ "Hack" ]; };
in {
  fonts = {
    fonts = (with pkgs; [ dejavu_fonts noto-fonts-emoji ]) ++ [ hack-font ];
    fontDir.enable = true;
  };
}
