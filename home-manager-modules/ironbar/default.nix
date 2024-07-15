# https://github.com/JakeStanger/ironbar/wiki/configuration-guide
_: {
  programs.ironbar = {
    enable = true;
    systemd = true;
    config = {
      monitors = {
        DP-2 = {
          #icon_theme = "Tela-circle-dracula";
          position = "top";
          height = 32;
          start = [
            {
              type = "label";
              label = "󱄅";
              name = "nix";
            }
            {
              type = "workspaces";
              all_monitors = false;
            }
            {
              type = "launcher";
              show_names = false;
              show_icons = true;
            }
          ];
          center = [{
            type = "clock";
            format = "%R - %a %d.";
          }];
          end = [
            {
              type = "sys_info";
              format = [
                "   {cpu_percent}% | {temp_c:coretemp-Package-id-0}°C"
                "   {memory_percent}%"
              ];
              interval = {
                cpu = 1;
                temps = 5;
                memory = 30;
              };
            }
            { type = "tray"; }
            {
              type = "volume";
              format = "{icon} {percentage}%";
              max_volume = 100;
              icons = {
                volume_high = "󰕾";
                volume_medium = "󰖀";
                volume_low = "󰕿";
                volume_muted = "󰝟";
              };
            }
            {
              type = "custom";
              class = "power-menu";
              bar = [{
                type = "button";
                name = "power-btn";
                label = "";
                on_click = "popup:toggle";
              }];
              popup = [{
                type = "box";
                orientation = "vertical";
                widgets = [
                  {
                    type = "label";
                    name = "header";
                    label = "Power menu";
                  }
                  {
                    type = "box";
                    widgets = [
                      {
                        type = "button";
                        class = "power-btn";
                        label = "<span font-size='40pt'></span>";
                        on_click = "!shutdown now";
                      }
                      {
                        type = "button";
                        class = "power-btn";
                        label = "<span font-size='40pt'></span>";
                        on_click = "!reboot";
                      }
                    ];
                  }
                ];
              }];
            }
          ];
        };
      };
    };
    style = ''
      /* Catppuccin Mocha palette */
      @define-color rosewater #f5e0dc;
      @define-color flamingo  #f2cdcd;
      @define-color pink      #f5c2e7;
      @define-color mauve     #cba6f7;
      @define-color red       #f38ba8;
      @define-color maroon    #eba0ac;
      @define-color peach     #fab387;
      @define-color yellow    #f9e2af;
      @define-color green     #a6e3a1;
      @define-color teal      #94e2d5;
      @define-color sky       #89dceb;
      @define-color sapphire  #74c7ec;
      @define-color blue      #89b4fa;
      @define-color lavender  #b4befe;
      @define-color text      #cdd6f4;
      @define-color subtext1  #bac2de;
      @define-color subtext0  #a6adc8;
      @define-color overlay2  #9399b2;
      @define-color overlay1  #7f849c;
      @define-color overlay0  #6c7086;
      @define-color surface2  #585b70;
      @define-color surface1  #45475a;
      @define-color surface0  #313244;
      @define-color base      #1e1e2e;
      @define-color mantle    #181825;
      @define-color crust     #11111b;

      /* Main color definitions */
      @define-color color_bg           @base;
      @define-color color_bg_dark      @crust;
      @define-color color_border       @surface0;
      @define-color color_border_active @blue;
      @define-color color_text         @text;
      @define-color color_urgent       @red;

      /* -- base styles -- */

      * {
          font-family: Noto Sans Nerd Font, sans-serif;
          font-size: 16px;
          border: none;
          border-radius: 0;
      }

      box, menubar, button {
          background-color: @color_bg;
          background-image: none;
          box-shadow: none;
      }

      button, label {
          color: @color_text;
      }

      button:hover {
          background-color: @color_bg_dark;
      }

      scale trough {
          min-width: 1px;
          min-height: 2px;
      }

      /* -- Main styles -- */

      .background {
          background-color: transparent;
      }

      #bar {
          background-color: @base;
          border: 2px solid @mauve;
          border-radius: 8px;
          margin: 10px 20px;
          padding: 2px;
          box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
      }

      #bar #start,
      #bar #center,
      #bar #end {
          background-color: transparent;
      }

      .container {
          background-color: transparent;
      }

      .widget-container {
          background-color: transparent;
      }

      .widget {
          color: @text;
          font-family: "Noto Sans", sans-serif;
          font-size: 14px;
          padding: 0 8px;
      }

      .popup {
          background-color: @base;
          border: 1px solid @surface0;
          border-radius: 8px;
          padding: 8px;
      }

      /* Ensure widgets don't overflow the rounded corners */
      #bar > * {
          margin: 2px 0;
      }


      /* -- start section -- */
      #nix {
          font-size: 1.5em;
          margin-left: 5px;
          padding: 5px;
          margin-right: 5px;
      }

      /* -- clipboard -- */

      .clipboard {
          margin-left: 5px;
          font-size: 1.1em;
      }

      .popup-clipboard .item {
          padding-bottom: 0.3em;
          border-bottom: 1px solid @color_border;
      }

      /* -- clock -- */

      .clock {
          font-weight: bold;
          margin-left: 5px;
      }

      .popup-clock .calendar-clock {
          color: @color_text;
          font-size: 2.5em;
          padding-bottom: 0.1em;
      }

      .popup-clock .calendar {
          background-color: @color_bg;
          color: @color_text;
      }

      .popup-clock .calendar .header {
          padding-top: 1em;
          border-top: 1px solid @color_border;
          font-size: 1.5em;
      }

      .popup-clock .calendar:selected {
          background-color: @color_border_active;
      }

      /* -- launcher -- */

      .launcher .item {
          margin-right: 4px;
      }

      .launcher .item:not(.focused):hover {
          background-color: @color_bg_dark;
      }

      .launcher .open {
          border-bottom: 1px solid @color_text;
      }

      .launcher .focused {
          border-bottom: 1px solid @color_border_active;
      }

      .launcher .urgent {
          border-bottom-color: @color_urgent;
      }

      .popup-launcher {
          padding: 0;
      }

      .popup-launcher .popup-item:not(:first-child) {
          border-top: 1px solid @color_border;
      }

      /* -- music -- */

      .music:hover * {
          background-color: @color_bg_dark;
      }

      .popup-music .album-art {
          margin-right: 1em;
      }

      .popup-music .icon-box {
          margin-right: 0.4em;
      }

      .popup-music .title .icon, .popup-music .title .label {
          font-size: 1.7em;
      }

      .popup-music .controls *:disabled {
          color: @color_border;
      }

      .popup-music .volume .slider slider {
          border-radius: 100%;
      }

      .popup-music .volume .icon {
          margin-left: 4px;
      }

      .popup-music .progress .slider slider {
          border-radius: 100%;
      }

      /* notifications */

      .notifications .count {
          font-size: 0.6rem;
          background-color: @color_text;
          color: @color_bg;
          border-radius: 100%;
          margin-right: 3px;
          margin-top: 3px;
          padding-left: 4px;
          padding-right: 4px;
          opacity: 0.7;
      }

      /* -- script -- */

      .script {
          padding-left: 10px;
      }

      /* -- sys_info -- */

      .sysinfo {
          margin-left: 10px;
      }

      .sysinfo .item {
          margin-left: 5px;
      }

      /* -- tray -- */

      .tray {
          margin-left: 10px;
      }

      /* -- volume -- */

      .popup-volume .device-box {
          border-right: 1px solid @color_border;
      }

      /* -- workspaces -- */

      .workspaces .item.focused {
          box-shadow: inset 0 -3px;
          background-color: @color_bg_dark;
      }

      .workspaces .item:hover {
          box-shadow: inset 0 -3px;
      }

      /* -- custom: power menu -- */

      .popup-power-menu #header {
          font-size: 1.4em;
          padding-bottom: 0.4em;
          margin-bottom: 0.6em;
          border-bottom: 1px solid @color_border;
      }

      .popup-power-menu .power-btn {
          border: 1px solid @color_border;
          padding: 0.6em 1em;
      }

      .popup-power-menu #buttons > *:nth-child(1) .power-btn {
          margin-right: 1em;
      }
    '';
  };
}
