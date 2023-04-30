{ pkgs, osConfig }:
let
  inherit (pkgs) procps system wofi pamixer;
  inherit (osConfig.flake.packages.${system})
    wofi-power waybar-screenshot waybar-colour-picker;
in [{
  layer = "top";
  position = "top";
  modules-left = [ "custom/launcher" "tray" ];
  modules-center = [ "clock" ];
  modules-right = [
    "custom/colour-picker"
    "custom/screenshot"
    "idle_inhibitor"
    "pulseaudio"
    "memory"
    "cpu"
    "network"
    "battery"
    "custom/powermenu"
  ];

  "custom/launcher" = {
    format = "  ";
    on-click = "${wofi}/bin/wofi --show drun";
    tooltip = false;
  };

  idle_inhibitor = {
    format = "{icon}";
    format-icons = {
      activated = "󰅶";
      deactivated = "󰛊";
    };
    tooltip = false;
  };

  backlight = {
    device = "intel_backlight";
    on-scroll-up = "light -A 5";
    on-scroll-down = "light -U 5";
    format = "{icon} {percent}%";
    format-icons = [ "" "" "" "" ];
  };

  pulseaudio = {
    scroll-step = 5;
    format = "{icon} {volume}%";
    format-muted = "婢 Muted";
    format-icons = { default = [ "" "" "" ]; };
    on-click = "${pamixer}/bin/pamixer -t";
    tooltip = false;
  };

  battery = {
    interval = 10;
    states = {
      warning = 20;
      critical = 10;
    };
    format = "{icon} {capacity}%";
    format-icons = [ "" "" "" "" "" "" "" "" "" ];
    format-full = "{icon} {capacity}%";
    format-charging = " {capacity}%";
    tooltip = false;
  };

  clock = {
    interval = 1;
    format = "{:%I:%M %p  %A %b %d}";
    tooltip = true;
    tooltip-format = ''
      {=%A; %d %B %Y}
      <tt>{calendar}</tt>'';
  };

  memory = {
    interval = 1;
    format = "󰘚 {used}/{total} GB ({percentage}%)";
    states = { warning = 85; };
  };

  cpu = {
    interval = 1;
    format = " {usage}%";
  };

  network = {
    interval = 1;
    format-wifi = "說 {essid}";
    format-ethernet = "  {ifname} ({ipaddr})";
    format-linked = "說 {essid} (No IP)";
    format-disconnected = "說 Disconnected";
  };

  temperature = {
    tooltip = false;
    format = " {temperatureC}°C";
  };

  "custom/powermenu" = {
    format = "   ";
    on-click = "${procps}/bin/pkill wofi || ${wofi-power}/bin/wofi-power";
    tooltip = false;
  };

  "custom/screenshot" = {
    format = "  ";
    format-icons = {
      activated = "  ";
      deactivated = "  ";
    };
    on-click = "${waybar-screenshot}/bin/waybar-screenshot";
  };

  "custom/colour-picker" = {
    format = "  ";
    on-click = "${waybar-colour-picker}/bin/waybar-colour-picker";
  };

  tray = {
    icon-size = 15;
    spacing = 5;
  };
}]
