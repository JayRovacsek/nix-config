{ pkgs, self, ... }:
let
  inherit (self.common.colour-schemes) tomorrow-night-blue-base16;

  hack-font = pkgs.nerd-fonts.hack;
in
{
  home-manager.sharedModules = [
    { stylix.targets.vscodium.enable = false; }
    { stylix.targets.hyprland.enable = false; }
  ];

  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = tomorrow-night-blue-base16;
    fonts = {
      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts;
      };

      monospace = {
        name = "Hack Nerd Font";
        package = hack-font;
      };

      sansSerif = {
        name = "DejaVu Sans";
        # So the below is super wonky - on aarch64 builds for the rpi3 it'll
        # receive a invalid shasum, but no other time. For now we'll utilise
        # the same font package between sansSerif and serif to resolve this
        # but it may cause wonkiness in some settings re; fonts
        package = pkgs.dejavu_fonts;
      };

      serif = {
        name = "DejaVu Serif";
        package = pkgs.dejavu_fonts;
      };

      sizes =
        let
          small = 10;
          medium = 12;
        in
        {
          applications = small;
          desktop = medium;
          popups = small;
          terminal = medium;
        };
    };
    homeManagerIntegration.followSystem = true;
    polarity = "dark";
  };
}
