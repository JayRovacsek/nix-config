{ pkgs, lib, ... }:
let
  hack-font = pkgs.nerdfonts.override { fonts = [ "Hack" ]; };
  inherit (pkgs.stdenv) isDarwin;

in
{
  home.packages = [ hack-font ];

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        dimensions = {
          columns = 0;
          lines = 0;
        };
        padding = {
          x = 7;
          y = 7;
        };
        dynamic_title = false;
        dynamic_padding = false;
        startup_mode = "Windowed";
        decorations = if isDarwin then "buttonless" else "None";
      };

      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      font = {
        normal = {
          family = lib.mkForce "Hack Nerd Font";
        };
        offset = {
          x = 0;
          y = 0;
        };
        glyph_offset = {
          x = 0;
          y = 0;
        };
      };

      bell = {
        animation = "EaseOutExpo";
        duration = 0;
        color = "0xffffff";
      };

      mouse.hide_when_typing = true;

      selection = {
        semantic_escape_chars = '',│`|:"' ()[]{}<>'';
        save_to_clipboard = false;
      };

      cursor = {
        style = "Block";
        unfocused_hollow = true;
      };

      general.live_config_reload = true;
    };
  };
}
