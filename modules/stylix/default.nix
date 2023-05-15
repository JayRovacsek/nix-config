{ config, pkgs, lib, ... }:
let
  inherit (pkgs) system stdenv;
  inherit (stdenv) isDarwin;
  inherit (config.flake.packages.${system}.colour-schemes)
    tomorrow-night-blue-base16;
in {
  stylix = {
    autoEnable = true;
    base16Scheme =
      "${tomorrow-night-blue-base16}/share/themes/tomorrow-night-blue.yaml";
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

      sizes = let
        small = 10;
        large = 14;
      in {
        desktop = large;
        applications = small;
        terminal = large;
        popups = small;
      };
    };

    homeManagerIntegration.followSystem = true;
    image = pkgs.fetchurl {
      url = "https://openclipart.org/image/2000px/311101";
      sha256 = "sha256-mIMXYOENVSgH0PjhO02MM7beg9AT44uVDj/tXxilDx0=";
    };
    polarity = "dark";
  };

  home-manager.sharedModules = [ ]
    ++ (lib.optionals isDarwin [{ stylix.targets.swaylock.enable = false; }]);
}
