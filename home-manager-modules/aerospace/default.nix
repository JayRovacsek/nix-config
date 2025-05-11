{ pkgs, ... }:
{
  programs.aerospace = {
    enable = true;

    userSettings = {
      start-at-login = true;

      # Normalizations. See: https://nikitabobko.github.io/AeroSpace/guide#normalization
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = false;
      after-startup-command = [
        "exec-and-forget ${pkgs.jankyborders}/bin/borders style=round width=10 active_color=0x00003f8e"
      ];

      # Window detection. See: https://nikitabobko.github.io/AeroSpace/guide.html#on-window-detected-callback
      # Common app ids: https://nikitabobko.github.io/AeroSpace/goodness#popular-apps-ids
      # This is a workaround for apps that have no window decorations not being detected.
      # on-window-detected = [{
      #   "if" = { app-id = "net.kovidgoyal.kitty"; };
      #   run = [ "layout tiling" ];
      # }];

      #workspace-to-monitor-force-assignment = {
      #  "1" = [ "C34H89x" 2 3 ];
      #  "2" = [ "C34H89x" 2 3 ];
      #  "3" = [ "C34H89x" 2 3 ];
      #  "4" = [ "^built-in retina display$" ];
      #  "5" = [ "^built-in retina display$" ];
      #};

      gaps = {
        inner = {
          horizontal = 10;
          vertical = 10;
        };
        outer = {
          left = 10;
          bottom = 10;
          top = 10;
          right = 10;
        };
      };

      # All possible keys:
      # - Letters.        a, b, c, ..., z
      # - Numbers.        0, 1, 2, ..., 9
      # - Keypad numbers. keypad0, keypad1, keypad2, ..., keypad9
      # - F-keys.         f1, f2, ..., f20
      # - Special keys.   minus, equal, period, comma, slash, backslash, quote, semicolon, backtick,
      #                   leftSquareBracket, rightSquareBracket, space, enter, esc, backspace, tab
      # - Keypad special. keypadClear, keypadDecimalMark, keypadDivide, keypadEnter, keypadEqual,
      #                   keypadMinus, keypadMultiply, keypadPlus
      # - Arrows.         left, down, up, right

      mode = {
        main.binding = {
          "alt-h" = [ ]; # Disable alt-h hiding windows
          "alt-f" = "flatten-workspace-tree"; # The oh-shit I fucked up, hit reset button
          "alt-q" = "close";
          "alt-slash" = "layout tiles horizontal vertical";

          # Focus active window in direction
          "alt-left" =
            "focus left --boundaries all-monitors-outer-frame --boundaries-action wrap-around-all-monitors";
          "alt-down" = "focus down";
          "alt-up" = "focus up";
          "alt-right" =
            "focus right --boundaries all-monitors-outer-frame --boundaries-action wrap-around-all-monitors";

          # move a window in direction
          # "alt-shift-left" = "move left";
          # "alt-shift-down" = "move down";
          # "alt-shift-up" = "move up";
          # "alt-shift-right" = "move right";

          # Move window to a monitor in general direction
          "alt-shift-ctrl-left" = "move-node-to-monitor left";
          "alt-shift-ctrl-down" = "move-node-to-monitor down";
          "alt-shift-ctrl-up" = "move-node-to-monitor up";
          "alt-shift-ctrl-right" = "move-node-to-monitor right";

          # Cycle through workspaces
          "alt-tab" = "workspace-back-and-forth";

          # Float a window
          "alt-shift-f" = "layout floating tiling"; # "floating toggle" in i3

          # Workspaces replace MacOS native Virtual Desktops
          # "alt-1" = "workspace 1";
          # "alt-2" = "workspace 2";
          # "alt-3" = "workspace 3";
          # "alt-4" = "workspace 4";
          # "alt-5" = "workspace 5";
          # "alt-6" = "workspace 6";
          # "alt-7" = "workspace 7";
          # "alt-8" = "workspace 8";
          # "alt-9" = "workspace 9";
          # "alt-0" = "workspace 10";

          # "alt-shift-1" = "move-node-to-workspace 1";
          # "alt-shift-2" = "move-node-to-workspace 2";
          # "alt-shift-3" = "move-node-to-workspace 3";
          # "alt-shift-4" = "move-node-to-workspace 4";
          # "alt-shift-5" = "move-node-to-workspace 5";
          # "alt-shift-6" = "move-node-to-workspace 6";
          # "alt-shift-7" = "move-node-to-workspace 7";
          # "alt-shift-8" = "move-node-to-workspace 8";
          # "alt-shift-9" = "move-node-to-workspace 9";
          # "alt-shift-0" = "move-node-to-workspace 10";

          "alt-r" = "mode resize";
        };

        resize.binding = {
          "left" = "resize width -50";
          "up" = "resize height +50";
          "down" = "resize height -50";
          "right" = "resize width +50";
          "enter" = "mode main";
          "esc" = "mode main";
        };
      };

    };
  };
}
