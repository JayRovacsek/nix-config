{ pkgs, osConfig }:
let
  inherit (pkgs) brightnessctl procps system pamixer wlogout;
  inherit (osConfig.flake.packages.${system}) waybar-screenshot;
in [{
  layer = "top";
  position = "top";
  modules-left = [ "tray" ];
  modules-center = [ "clock" ];
  modules-right = [
    "custom/screenshot"
    "idle_inhibitor"
    "pulseaudio"
    "memory"
    "cpu"
    "network"
    "backlight"
    "battery"
    "custom/powermenu"
  ];

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
    on-scroll-up = "${brightnessctl}/bin/brightnessctl s 5%+";
    on-scroll-down = "${brightnessctl}/bin/brightnessctl s 5%-";
    format = "{icon} {percent}%";
    format-icons = [ "󱩏" "󱩐" "󱩑" "󱩒" "󱩓" "󱩔" "󱩕" "󱩖" "󰛨" ];
  };

  pulseaudio = {
    scroll-step = 5;
    format = "{icon}  {volume}%";
    format-muted = "󰓄 Muted";
    format-icons = { default = [ "" "" "" ]; };
    on-click = "${pamixer}/bin/pamixer -t";
    tooltip = false;
  };

  battery = {
    interval = 20;
    states = {
      warning = 20;
      critical = 10;
    };
    format = "{icon}   {capacity}%";
    format-icons = [ "" "" "" "" "" "" ];
    format-full = "{icon} {capacity}%";
    format-charging = "󰂄 {capacity}%";
    tooltip = false;
  };

  clock = {
    interval = 60;
    format = "{:%I:%M %p %a %b %d, %G}";
  };

  memory = {
    interval = 1;
    format = "󰘚  {used}/{total} GB ({percentage}%)";
    states = { warning = 85; };
  };

  cpu = {
    interval = 1;
    format = "   {usage}%";
  };

  network = {
    interval = 1;
    format-wifi = "󰀂  {essid}";
    format-ethernet = "󱫋  {ifname} ({ipaddr})";
    format-linked = "󱫋  {essid} (No IP)";
    format-disconnected = "󰯡  Disconnected";
  };

  temperature = {
    tooltip = false;
    format = " {temperatureC}°C";
  };

  "custom/powermenu" = {
    format = "   ";
    on-click = "${procps}/bin/pkill wlogout || ${wlogout}/bin/wlogout";
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

  tray = {
    icon-size = 15;
    spacing = 5;
  };
}]
