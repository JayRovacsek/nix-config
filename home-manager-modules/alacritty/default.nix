{ pkgs, ... }: {
  programs.alacritty = {
    enable = true;
    settings = {
      shell.program = "${pkgs.zsh}/bin/zsh";
      window = {
        dimensions = {
          columns = 0;
          lines = 0;
        };
        padding = {
          x = 2;
          y = 2;
        };
        dynamic_title = false;
        dynamic_padding = false;
        decorations = "full";
        startup_mode = "Windowed";
      };

      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      font = {
        offset = {
          x = 0;
          y = 0;
        };
        glyph_offset = {
          x = 0;
          y = 0;
        };
      };

      draw_bold_text_with_bright_colors = true;

      bell.animation = "EaseOutExpo";
      bell.duration = 0;
      bell.color = "0xffffff";

      mouse.hide_when_typing = true;

      selection.semantic_escape_chars = '',│`|:"' ()[]{}<>'';
      selection.save_to_clipboard = false;

      cursor.style = "Block";
      cursor.unfocused_hollow = true;
      live_config_reload = true;
    };
  };
}
