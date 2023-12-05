{
  "*" = {
    border = "none";
    border-radius = 0;
    font-size = "13px";
    min-height = 0;
  };

  "window#waybar" = {
    background-color = "transparent";
    color = "white";
    transition-property = "background-color";
    transition-duration = "0.5s";
  };

  "window#waybar.hidden" = { opacity = "0.2"; };

  "window#waybar.termite" = { background-color = "#3f3f3f"; };

  "window#waybar.chromium" = {
    background-color = "#000000";
    border = "none";
  };

  "#workspaces button" = {
    padding = "0 5px";
    background-color = "transparent";
    color = "#ffffff";
  };

  # https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect
  "#workspaces button:hover" = {
    background = "transparent";
    box-shadow = "inherit";
    text-shadow = "inherit";
    color = "rgb(250, 250, 140)";
  };

  "#workspaces button.focused" = { color = "rgb(150, 255, 146)"; };

  "#workspaces button.urgent" = { background-color = "#eb4d4b"; };

  "#mode" = {
    background-color = "rgb(20, 30, 60)";
    color = "white";
    padding = "5px";
  };

  "#clock,#battery,#cpu,#memoryj #disk,#temperature,#backlight,#network,#bluetooth,#pulseaudio,#custom-media,#tray,#idle_inhibitor,#mpd" =
    {
      border-radius = "20px";
      padding = "0 5px";
      margin = "5px 3px";
      color = "#ffffff";
    };

  "#window,#workspaces" = { margin-left = "7px"; };

  # If workspaces is the leftmost module, omit left margin
  ".modules-left > widget:first-child > #workspaces" = { margin-left = 0; };

  "#battery.charging,#battery.plugged" = {
    color = "#ffffff";
    background-color = "#26a65b";
  };

  "@keyframes blink" = {
    to = {
      background-color = "#ffffff";
      color = "#000000";
    };
  };

  "#battery.critical:not(.charging)" = {
    background-color = "#f53c3c";
    color = "#ffffff";
  };

  "label:focus" = { background-color = "#000000"; };

  "#tray" = {
    "background-color" = "#2980b9";
    "margin-right" = "20px";
  };

  "#tray > .passive" = { "-gtk-icon-effect" = "dim"; };
  "#tray > .needs-attention" = {
    "-gtk-icon-effect" = "highlight";
    "background-color" = "#eb4d4b";
  };

  "#language" = {
    "background" = "#00b093";
    "color" = "#740864";
    "padding" = "0 5px";
    "margin" = "0 5px";
    "min-width" = "16px";
  };

  "keyboard-state" = {
    "background" = "#97e1ad";
    "color" = "#000000";
    "padding" = "0 0px";
    "margin" = "0 5px";
    "min-width" = "16px";
  };

  "#keyboard-state > label" = { padding = "0 5px"; };

  "#keyboard-state > label.locked" = { background = "rgba(0, 0, 0, 0.2)"; };
}
