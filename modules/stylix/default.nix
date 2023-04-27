{ config, pkgs, ... }:
let
  inherit (pkgs) system;
  inherit (config.flake.inputs.nixpkgs.legacyPackages.${system}) base16-schemes;
  # inherit (config.flake.packages.${system}) catppuccin-base16;
in {
  stylix = {
    autoEnable = true;
    base16Scheme = "${base16-schemes}/share/themes/snazzy.yaml";
    # base16Scheme = "${catppuccin-base16}/share/base16/latte.yaml";
    fonts = {
      sansSerif = {
        package = pkgs.ibm-plex;
        name = "IBM Plex Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "IBM Plex Serif";
      };
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "Hack" ]; };
        name = "Hack Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

      sizes = rec {
        desktop = 14;
        applications = 10;
        terminal = applications;
        popups = applications;
      };
    };
    homeManagerIntegration.followSystem = true;
    image = pkgs.fetchurl {
      url = "https://openclipart.org/image/2000px/311101";
      sha256 = "sha256-mIMXYOENVSgH0PjhO02MM7beg9AT44uVDj/tXxilDx0=";
    };
    polarity = "dark";
  };
}
