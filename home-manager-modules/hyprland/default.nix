{ pkgs, osConfig, ... }:
let
  inherit (pkgs) system mpvpaper waybar;
  inherit (osConfig.flake.lib) generate-hyprland-monitors;
  inherit (osConfig.flake.packages.${system}) sunset-river-pixelart-wallpaper;

  nvidiaPatches = builtins.any (driver: driver == "nvidia")
    osConfig.services.xserver.videoDrivers;

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
      name = "DP-4";
      resolution = "1920x1080";
      position = "3000x420";
      scale = "1";
      extra = "";
    }
    {
      name = "DP-5";
      resolution = "1920x1080";
      position = "4920x420";
      scale = "1";
      extra = "";
    }
  ];

  monitors = if osConfig.networking.hostName == "alakazam" then
    (generate-hyprland-monitors alakazam-monitors)
  else
    "monitor=,preferred,auto,auto";
in {

  imports = [ ../waybar ../wofi ];

  wayland.windowManager.hyprland = {
    enable = true;
    inherit nvidiaPatches;
    extraConfig = ''
      # Please note not all available settings / options are set here.
      # For a full list, see the wiki
      # See https://wiki.hyprland.org/Configuring/Monitors/
      # See https://wiki.hyprland.org/Configuring/Keywords/
      # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
      ${monitors}

      env = XCURSOR_SIZE,24
      input {
          kb_layout = us
          follow_mouse = 1
          touchpad {
              natural_scroll = false
          }
          sensitivity = 0 
      }

      general {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more

          gaps_in = 5
          gaps_out = 20
          border_size = 2
          col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
          col.inactive_border = rgba(595959aa)

          layout = dwindle
      }

      # https://wiki.hyprland.org/Configuring/Variables/#decoration
      decoration {
          rounding = 5
          blur = true
          blur_size = 3
          blur_passes = 1
          blur_ignore_opacity = false
          blur_new_optimizations = true
          drop_shadow = true
          shadow_range = 4
          shadow_render_power = 3
          col.shadow = rgba(1a1a1aee)
      }

      # https://wiki.hyprland.org/Configuring/Variables/#animations
      animations {
          enabled = true
          bezier = myBezier, 0.05, 0.9, 0.1, 1.05
          animation = windows, 1, 7, myBezier
          animation = windowsOut, 1, 7, default, popin 80%
          animation = border, 1, 10, default
          animation = borderangle, 1, 8, default
          animation = fade, 1, 7, default
          animation = workspaces, 1, 6, default
      }

      # https://wiki.hyprland.org/Configuring/Dwindle-Layout/
      dwindle {
          pseudotile = true
          preserve_split = true
      }

      # https://wiki.hyprland.org/Configuring/Master-Layout/ 
      master {
          new_is_master = true
      }

      # https://wiki.hyprland.org/Configuring/Variables/#gestures
      gestures {
          workspace_swipe = false
      }

      # Window Rules
      # https://wiki.hyprland.org/Configuring/Window-Rules/
      windowrule = opacity 1.0 override 0.9 override,^(.*)$ 


      # https://wiki.hyprland.org/Configuring/Keywords/
      $mainMod = SUPER

      # Binds
      # https://wiki.hyprland.org/Configuring/Binds/
      bind = $mainMod, C, killactive,
      bind = $mainMod, M, exit,V
      bind = $mainMod, V, togglefloating,
      bind = CTRL SHIFT, Space, exec, wofi --show drun
      bind = $mainMod, P, pseudo, # dwindle
      bind = $mainMod, J, togglesplit, # dwindle

      # Move focus with mainMod + arrow keys
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d

      # Switch workspaces with mainMod + [0-9]
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      # TODO: Add mod/extra key to this to avoid
      # using the same bind as common text editors
      bind = $mainMod CTRL SHIFT,left ,movewindow, l
      bind = $mainMod CTRL SHIFT,right ,movewindow, r
      bind = $mainMod CTRL SHIFT,up ,movewindow, u
      bind = $mainMod CTRL SHIFT,down ,movewindow, d

      # Scroll through existing workspaces with mainMod + scroll
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

      exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
      # The below does not work :sadpanda:
      exec-once=${mpvpaper}/bin/mpvpaper -sf -o "--loop --panscan=1" '*' ${sunset-river-pixelart-wallpaper}/share/wallpaper.mp4
      exec-once=${waybar}/bin/waybar
    '';
  };
}
