{ config, pkgs, osConfig, ... }:
let
  inherit (pkgs) lib system mpvpaper systemd wofi nextcloud-client;
  inherit (osConfig.flake.lib.hyprland) generate-monitors generate-config;
  inherit (osConfig.flake.packages.${system}.wallpapers)
    may-sitting-near-waterfall-pokemon-emerald;

  nvidia-present = builtins.any (driver: driver == "nvidia")
    osConfig.services.xserver.videoDrivers;

  rpi-present = (builtins.hasAttr "raspberry-pi" osConfig.hardware)
    && osConfig.hardware.raspberry-pi."4".fkms-3d.enable;

  nvidia-hardware-flags =
    lib.optionalString nvidia-present "--vo=gpu --hwdec=nvdec-copy";

  rpi-hardware-flags = lib.optionalString rpi-present "--opengl-glfinish=yes";

  hardware-wallpaper =
    lib.concatStringsSep " " [ nvidia-hardware-flags rpi-hardware-flags ];

  alakazam-monitors = [
    {
      name = "DVI-D-1";
      resolution = "1920x1080";
      position = "0x0";
      scale = "1";
      extra = "transform,1";
    }
    {
      name = "HDMI-A-1";
      resolution = "1920x1080";
      position = "1080x420";
      scale = "1";
      extra = "";
    }
    {
      name = "DP-2";
      resolution = "1920x1080";
      position = "4920x420";
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
  ];
  monitor = if osConfig.networking.hostName == "alakazam" then
    (generate-monitors alakazam-monitors)
  else
    [ ",preferred,auto,auto" ];

  mpvpaper-exec = ''
    ${mpvpaper}/bin/mpvpaper -sf -o "no-audio --loop --panscan=1 ${hardware-wallpaper}" '*' ${may-sitting-near-waterfall-pokemon-emerald}/share/wallpaper.mp4'';

  waybar-exec = "${systemd}/bin/systemctl --user start waybar.service";

  nextcloud-present = builtins.any (p: (p.pname or "") == "nextcloud-client")
    config.home.packages;

  nextcloud-exec =
    lib.optional nextcloud-present "${nextcloud-client}/bin/nextcloud";

  exec-once = [ mpvpaper-exec waybar-exec ] ++ nextcloud-exec;

in generate-config {
  inherit exec-once monitor;

  env = "XCURSOR_SIZE,24";
  input = {
    kb_layout = "us";
    follow_mouse = 1;
    touchpad = { natural_scroll = false; };
    sensitivity = 0;
  };

  general = {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more
    gaps_in = 5;
    gaps_out = 20;
    border_size = 2;
    "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
    "col.inactive_border" = "rgba(595959aa)";

    layout = "dwindle";
  };

  # https://wiki.hyprland.org/Configuring/Variables/#decoration
  decoration = {
    rounding = 5;
    blur = true;
    blur_size = 3;
    blur_passes = 1;
    blur_ignore_opacity = false;
    blur_new_optimizations = true;
    drop_shadow = true;
    shadow_range = 4;
    shadow_render_power = 3;
    "col.shadow" = "rgba(1a1a1aee)";
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

  # https://wiki.hyprland.org/Configuring/Master-Layout/ 
  master = { new_is_master = true; };

  # https://wiki.hyprland.org/Configuring/Variables/#gestures
  gestures = { workspace_swipe = false; };

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
    "CTRL SHIFT, Space, exec, ${wofi}/bin/wofi --show drun --insensitive"
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
  ];

  # Move/resize windows with mainMod + LMB/RMB and dragging
  bindm =
    [ "$mainMod, mouse:272, movewindow" "$mainMod, mouse:273, resizewindow" ];

}
