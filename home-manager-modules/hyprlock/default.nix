{ pkgs, self, ... }:
let
  inherit (pkgs) system;
  inherit (self.packages.${system}) mario-homelab-pixelart-wallpaper;
in
{
  programs.hyprlock = {
    enable = true;
    settings = {
      # BACKGROUND
      background = {
        monitor = "";
        path = "${mario-homelab-pixelart-wallpaper}/share/wallpaper.jpg";
        blur_size = 4;
        blur_passes = 3;
        noise = 1.17e-2;
        contrast = 0.8916;
        brightness = 0.8172;
        vibrancy = 0.1696;
        vibrancy_darkness = 0.0;
      };

      # GENERAL
      general = {
        no_fade_in = false;
        grace = 0;
        disable_loading_bar = true;
      };

      # TIME
      label = [
        {
          # TIME
          monitor = "";
          text = ''cmd[update:500] echo "<b><big> $(date +"%H:%M:%S") </big></b>"'';
          #color = rgba(255, 255, 255, 0.6)
          font_size = 64;
          font_family = "Hack Nerd Font Mono";
          position = "0, 16";
          shadow_passes = 3;
          shadow_size = 4;
          halign = "center";
          valign = "center";
        }
      ];

      # INPUT FIELD
      input-field = {
        monitor = "";
        size = "250, 50";
        outline_thickness = 3;
        dots_size = 0.26; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.64; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
        outer_color = "rgba(0, 0, 0, 0)";
        inner_color = "rgba(0, 0, 0, 0.5)";
        font_color = "rgb(200, 200, 200)";
        fade_on_empty = false;
        font_family = "Hack Nerd Font Mono";
        placeholder_text = "<i><span foreground='##cdd6f4'>Password...</span></i>";
        hide_input = false;
        position = "0, 50";
        halign = "center";
        valign = "bottom";
      };
    };
  };
}
