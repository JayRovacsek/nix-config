{ pkgs, self, ... }:
let
  inherit (pkgs) system;
  inherit (self.packages.${system}) eww-sleek-bar;

  hack-font = pkgs.nerd-fonts.hack;
in
{
  home.packages = [
    hack-font
    pkgs.dejavu_fonts
  ];

  programs.eww = {
    enable = true;
    package = pkgs.eww;
    configDir = "${eww-sleek-bar}/share";
  };
}
