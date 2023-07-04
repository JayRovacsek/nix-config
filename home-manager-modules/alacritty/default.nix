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
        startup_mode = "Windowed";
        decorations = "none";
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

      live_config_reload = true;
    };
  };
}
