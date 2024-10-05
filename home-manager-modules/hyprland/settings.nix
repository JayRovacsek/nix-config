{
  config,
  osConfig,
  pkgs,
  self,
}:
let
  inherit (osConfig.networking) hostName;

  inherit (pkgs)
    grim
    hyprlock
    slurp
    swappy
    lib
    fuzzel
    nextcloud-client
    ;
  inherit (self.lib.hyprland) generate-monitors;

  inherit (self.common.colour-schemes.tomorrow-night-blue-base16)
    base01
    base02
    base03
    ;

  alakazam-monitors = [
    {
      name = "DVI-D-1";
      resolution = "1920x1080";
      position = "0x0";
      scale = "1";
      extra = "transform,1";
    }
    {
      name = "DP-2";
      resolution = "1920x1080";
      position = "1080x420";
      scale = "1";
      extra = "";
    }
    {
      name = "DP-3";
      resolution = "1920x1080";
      position = "3000x420";
      scale = "1";
      extra = "";
    }
    {
      name = "HDMI-A-1";
      resolution = "1920x1080";
      position = "4920x420";
      scale = "1";
      extra = "";
    }
  ];

  monitor =
    if hostName == "alakazam" then
      (generate-monitors alakazam-monitors)
    else
      [ ",preferred,auto,auto" ];

  bluetooth-enabled =
    osConfig.hardware.bluetooth.enable || osConfig.services.blueman.enable;

  nextcloud-present = builtins.any (
    p: (p.pname or "") == "nextcloud-client"
  ) config.home.packages;

  swaync-enabled = config.services.swaync.enable;

  bluetooth-exec = lib.optional bluetooth-enabled "${pkgs.blueman}/bin/blueman-applet";

  swaync-exec = lib.optional swaync-enabled "${config.services.swaync.package}/bin/swaync";

  nextcloud-exec = lib.optional nextcloud-present "${nextcloud-client}/bin/nextcloud";

  exec-once = bluetooth-exec ++ nextcloud-exec ++ swaync-exec;

in
{
  inherit exec-once monitor;

  env = "XCURSOR_SIZE,24";
  input = {
    kb_layout = "us";
    follow_mouse = 1;
    touchpad = {
      natural_scroll = false;
    };
    sensitivity = 0;
  };

  general = {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more
    gaps_in = 5;
    gaps_out = 5;
    border_size = 2;
    "col.active_border" = "rgba(${base03}ee)";
    "col.inactive_border" = "rgba(${base02}aa)";

    layout = "dwindle";
  };

  # https://wiki.hyprland.org/Configuring/Variables/#decoration
  decoration = {
    rounding = 5;
    drop_shadow = true;
    shadow_range = 4;
    shadow_render_power = 3;
    "col.shadow" = "rgba(${base01}ee)";
  };

  # https://wiki.hyprland.org/Configuring/Variables/#animations
  animations = {
    enabled = true;
    animation = [
      "windowsOut, 1, 7, default, popin 80%"
      "border, 1, 10, default"
      "borderangle, 1, 8, default"
      "fade, 1, 7, default"
      "workspaces, 1, 6, default"
    ];
  };

  # https://wiki.hyprland.org/Configuring/Dwindle-Layout/
  dwindle = {
    pseudotile = true;
    preserve_split = true;
  };

  # https://wiki.hyprland.org/Configuring/Variables/#gestures
  gestures = {
    workspace_swipe = false;
  };

  # Window Rules
  # https://wiki.hyprland.org/Configuring/Window-Rules/
  windowrule = "opacity 1.0 override 0.9 override,^(.*)$";

  # https://wiki.hyprland.org/Configuring/Keywords/
  "$mainMod" = "SUPER";

  # Binds
  # https://wiki.hyprland.org/Configuring/Binds/
  bind = [
    "$mainMod, Q, killactive,"
    "$mainMod, M, exit,V"
    "$mainMod, V, togglefloating,"
    "CTRL SHIFT, Space, exec, ${fuzzel}/bin/fuzzel --vertical-pad 50 --horizontal-pad 100 --show-actions --lines 20 --width 80"
    "$mainMod, P, pseudo, # dwindle"
    "$mainMod, J, togglesplit, # dwindle"

    # Move focus with mainMod + arrow keys
    "$mainMod, left, movefocus, l"
    "$mainMod, right, movefocus, r"
    "$mainMod, up, movefocus, u"
    "$mainMod, down, movefocus, d"

    # Move window location
    "$mainMod CTRL SHIFT,left ,movewindow, l"
    "$mainMod CTRL SHIFT,right ,movewindow, r"
    "$mainMod CTRL SHIFT,up ,movewindow, u"
    "$mainMod CTRL SHIFT,down ,movewindow, d"

    # Scroll through existing workspaces with mainMod + scroll
    "$mainMod, mouse_down, workspace, e+1"
    "$mainMod, mouse_up, workspace, e-1"

    # Print Screen
    '', code:107, exec, ${grim}/bin/grim -g "$(${slurp}/bin/slurp)" - | ${swappy}/bin/swappy -f -''

    # Lock
    "$mainMod, L, exec, pidof ${hyprlock}/bin/hyprlock || ${hyprlock}/bin/hyprlock"
  ];

  # Move/resize windows with mainMod + LMB/RMB and dragging
  bindm = [
    "$mainMod, mouse:272, movewindow"
    "$mainMod, mouse:273, resizewindow"
  ];

}
