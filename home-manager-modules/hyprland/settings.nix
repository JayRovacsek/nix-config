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
    ;
  inherit (self.lib.hyprland) generate-monitors;
  inherit (lib.generators) mkLuaInline;
  toLua = lib.generators.toLua { };

  inherit (self.common.colour-schemes.tomorrow-night-blue-base16)
    base02
    base03
    ;

  alakazam-monitors = [
    # Position 1
    {
      name = "HDMI-A-1";
      resolution = "1920x1080";
      position = "0x0";
      scale = "1";
    }
    # Position 2
    {
      name = "DP-4";
      resolution = "1920x1080";
      position = "1920x0";
      scale = "1";
    }
    # Position 3
    {
      name = "DP-3";
      resolution = "1920x1080";
      position = "3840x0";
      scale = "1";
    }
  ];

  monitor =
    if hostName == "alakazam" then
      (generate-monitors alakazam-monitors)
    else
      [
        {
          output = "";
          mode = "preferred";
          position = "auto";
          scale = "auto";
        }
      ];

  bluetooth-enabled =
    osConfig.hardware.bluetooth.enable || osConfig.services.blueman.enable;

  swaync-enabled = config.services.swaync.enable;

  bluetooth-exec = lib.optional bluetooth-enabled "${pkgs.blueman}/bin/blueman-applet";

  swaync-exec = lib.optional swaync-enabled "${config.services.swaync.package}/bin/swaync";

  exec-once = bluetooth-exec ++ swaync-exec;

  # Render the exec-once commands as a Lua startup hook.
  startup-commands = lib.concatMapStrings (
    cmd: "  hl.exec_cmd(${toLua cmd})\n"
  ) exec-once;

  startup-hook = mkLuaInline ("function()\n" + startup-commands + "end");

in
{
  # $mainMod becomes a Lua local referenced by the binds below.
  mainMod = {
    _var = "SUPER";
  };

  inherit monitor;

  env = {
    _args = [
      "XCURSOR_SIZE"
      "24"
    ];
  };

  config = {
    input = {
      kb_layout = "us";
      follow_mouse = 1;
      touchpad = {
        natural_scroll = false;
      };
      sensitivity = 0;
    };

    general = {
      # See https://wiki.hypr.land/Configuring/Variables/ for more
      gaps_in = 5;
      gaps_out = 5;
      border_size = 2;
      col = {
        active_border = "rgba(${base03}ee)";
        inactive_border = "rgba(${base02}aa)";
      };
    };

    ecosystem = {
      no_update_news = true;
    };

    # https://wiki.hypr.land/Configuring/Variables/#decoration
    decoration = {
      rounding = 5;
    };

    # https://wiki.hypr.land/Configuring/Variables/#animations
    animations = {
      enabled = true;
    };

    # https://wiki.hypr.land/Configuring/Dwindle-Layout/
    dwindle = {
      preserve_split = true;
    };
  };

  # https://wiki.hypr.land/Configuring/Variables/#animations
  animation = [
    {
      leaf = "windowsOut";
      enabled = true;
      speed = 7;
      bezier = "default";
      style = "popin 80%";
    }
    {
      leaf = "border";
      enabled = true;
      speed = 10;
      bezier = "default";
    }
    {
      leaf = "borderangle";
      enabled = true;
      speed = 8;
      bezier = "default";
    }
    {
      leaf = "fade";
      enabled = true;
      speed = 7;
      bezier = "default";
    }
    {
      leaf = "workspaces";
      enabled = true;
      speed = 6;
      bezier = "default";
    }
  ];

  # Binds
  # https://wiki.hypr.land/Configuring/Binds/
  bind = [
    # Kill active window
    {
      _args = [
        (mkLuaInline ''mainMod .. " + Q"'')
        (mkLuaInline "hl.dsp.window.close()")
      ];
    }

    # Exit Hyprland
    {
      _args = [
        (mkLuaInline ''mainMod .. " + M"'')
        (mkLuaInline "hl.dsp.exit()")
      ];
    }

    # Toggle floating
    {
      _args = [
        (mkLuaInline ''mainMod .. " + V"'')
        (mkLuaInline ''hl.dsp.window.float({ action = "toggle" })'')
      ];
    }

    # Application launcher
    {
      _args = [
        "CTRL + SHIFT + Space"
        (mkLuaInline ''hl.dsp.exec_cmd("${fuzzel}/bin/fuzzel --vertical-pad 50 --horizontal-pad 100 --show-actions --lines 20 --width 80")'')
      ];
    }

    # Pseudo tile
    {
      _args = [
        (mkLuaInline ''mainMod .. " + P"'')
        (mkLuaInline "hl.dsp.window.pseudo()")
      ];
    }

    # Move focus with mainMod + arrow keys
    {
      _args = [
        (mkLuaInline ''mainMod .. " + left"'')
        (mkLuaInline ''hl.dsp.focus({ direction = "left" })'')
      ];
    }
    {
      _args = [
        (mkLuaInline ''mainMod .. " + right"'')
        (mkLuaInline ''hl.dsp.focus({ direction = "right" })'')
      ];
    }
    {
      _args = [
        (mkLuaInline ''mainMod .. " + up"'')
        (mkLuaInline ''hl.dsp.focus({ direction = "up" })'')
      ];
    }
    {
      _args = [
        (mkLuaInline ''mainMod .. " + down"'')
        (mkLuaInline ''hl.dsp.focus({ direction = "down" })'')
      ];
    }

    # Move window location
    {
      _args = [
        (mkLuaInline ''mainMod .. " + CTRL + SHIFT + left"'')
        (mkLuaInline ''hl.dsp.window.move({ direction = "left" })'')
      ];
    }
    {
      _args = [
        (mkLuaInline ''mainMod .. " + CTRL + SHIFT + right"'')
        (mkLuaInline ''hl.dsp.window.move({ direction = "right" })'')
      ];
    }
    {
      _args = [
        (mkLuaInline ''mainMod .. " + CTRL + SHIFT + up"'')
        (mkLuaInline ''hl.dsp.window.move({ direction = "up" })'')
      ];
    }
    {
      _args = [
        (mkLuaInline ''mainMod .. " + CTRL + SHIFT + down"'')
        (mkLuaInline ''hl.dsp.window.move({ direction = "down" })'')
      ];
    }

    # Scroll through existing workspaces with mainMod + scroll
    {
      _args = [
        (mkLuaInline ''mainMod .. " + mouse_down"'')
        (mkLuaInline ''hl.dsp.focus({ workspace = "e+1" })'')
      ];
    }
    {
      _args = [
        (mkLuaInline ''mainMod .. " + mouse_up"'')
        (mkLuaInline ''hl.dsp.focus({ workspace = "e-1" })'')
      ];
    }

    # Print Screen
    {
      _args = [
        "code:107"
        (mkLuaInline ''hl.dsp.exec_cmd("${grim}/bin/grim -g \"$(${slurp}/bin/slurp)\" - | ${swappy}/bin/swappy -f -")'')
      ];
    }

    # Lock
    {
      _args = [
        (mkLuaInline ''mainMod .. " + L"'')
        (mkLuaInline ''hl.dsp.exec_cmd("pidof ${hyprlock}/bin/hyprlock || ${hyprlock}/bin/hyprlock")'')
      ];
    }

    # Move/resize windows with mainMod + LMB/RMB and dragging
    {
      _args = [
        (mkLuaInline ''mainMod .. " + mouse:272"'')
        (mkLuaInline "hl.dsp.window.drag()")
        { mouse = true; }
      ];
    }
    {
      _args = [
        (mkLuaInline ''mainMod .. " + mouse:273"'')
        (mkLuaInline "hl.dsp.window.resize()")
        { mouse = true; }
      ];
    }
  ];
}
// lib.optionalAttrs (exec-once != [ ]) {
  on = {
    _args = [
      "hyprland.start"
      startup-hook
    ];
  };
}
