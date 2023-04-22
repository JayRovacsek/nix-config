{ pkgs, osConfig }:
let
  inherit (pkgs) procps system wofi;
  inherit (osConfig.flake.packages.${system}) wofi-power;
in [{
  layer = "top";
  position = "top";
  modules-left =
    [ "custom/launcher" "wlr/workspaces" "temperature" "idle_inhibitor" ];
  modules-center = [ "clock" ];
  modules-right = [
    "pulseaudio"
    "backlight"
    "memory"
    "cpu"
    "network"
    "battery"
    "custom/powermenu"
    "tray"
  ];
  "custom/launcher" = {
    format = " ";
    on-click = "${wofi}/bin/wofi --show drun";
    tooltip = false;
  };
  "wlr/workspaces" = {
    format = "{icon}";
    on-click = "activate";
  };
  idle_inhibitor = {
    format = "{icon}";
    format-icons = {
      activated = "";
      deactivated = "";
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
    scroll-step = 1;
    format = "{icon} {volume}%";
    format-muted = "婢 Muted";
    format-icons = { default = [ "" "" "" ]; };
    states = { warning = 85; };
    on-click = "pamixer -t";
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
    format = "﬙ {percentage}%";
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
    tooltip = false;
  };
  temperature = {
    tooltip = false;
    format = " {temperatureC}°C";
  };
  "custom/powermenu" = {
    format = "";
    on-click = "${procps}/bin/pkill wofi || ${wofi-power}/bin/wofi-power";
    tooltip = false;
  };
  tray = {
    icon-size = 15;
    spacing = 5;
  };
}]
