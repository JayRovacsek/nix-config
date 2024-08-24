{ pkgs, self, ... }:
let
  inherit (self.common.colour-schemes) tomorrow-night-blue-base16;

  hack-font = pkgs.nerdfonts.override { fonts = [ "Hack" ]; };
in
{
  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = tomorrow-night-blue-base16;
    fonts = {
      sansSerif = {
        # So the below is super wonky - on aarch64 builds for the rpi3 it'll
        # receive a invalid shasum, but no other time. For now we'll utilise
        # the same font package between sansSerif and serif to resolve this 
        # but it may cause wonkiness in some settings re; fonts
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };

      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      monospace = {
        package = hack-font;
        name = "Hack Nerd Font";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

      sizes =
        let
          small = 10;
          medium = 12;
        in
        {
          desktop = medium;
          applications = small;
          terminal = medium;
          popups = small;
        };
    };

    homeManagerIntegration.followSystem = true;
    image = pkgs.fetchurl {
      url = "https://openclipart.org/image/2000px/311101";
      hash = "sha256-mIMXYOENVSgH0PjhO02MM7beg9AT44uVDj/tXxilDx0=";
    };
    polarity = "dark";
  };

  home-manager.sharedModules = [
    { stylix.targets.hyprland.enable = false; }
    { stylix.targets.vscode.enable = false; }
  ];
}
