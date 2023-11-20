{ config, pkgs, ... }:
let
  inherit (config.xdg) configHome;
  cfg = {
    address_family = "ipv4";
    origin_web_ui_allowed = "lan";
    port = 47989;
    resolutions = [
      "1280x720"
      "1920x1080"
      "2560x1080"
      "3440x1440"
      "1920x1200"
      "3840x2160"
      "3840x1600"
    ];
    upnp = "off";
  };

  apps-cfg = {
    env = { "PATH" = "$(PATH)=$(HOME)/.local/bin"; };
    apps = [
      {
        "name" = "Desktop";
        "image-path" = "desktop.png";
      }
      {
        "name" = "Steam Big Picture";
        "detached" = [ "setsid steam steam=//open/bigpicture" ];
        "image-path" = "steam.png";
      }
      {
        "name" = "Codium";
        "output" = "";
        "cmd" = "${pkgs.vscodium}/bin/codium";
        "exclude-global-prep-cmd" = "false";
        "elevated" = "false";
        "auto-detach" = "true";
        "image-path" = "";
        "working-dir" = "~/dev/personal/nix-config";
      }
    ];
  };
in {
  home.file = {
    "${configHome}/sunshine/sunshine.conf".text = builtins.toJSON cfg;
    "${configHome}/sunshine/apps.json".text = builtins.toJSON apps-cfg;
  };

  systemd.user.services.sunshine = {
    Install.WantedBy = [ "graphical-session.target" ];

    Service = {
      ExecStart = "${pkgs.sunshine}/bin/sunshine";
      Restart = "on-failure";
      RestartSec = "5s";
    };

    Unit = {
      Description = "Sunshine self-hosted game stream host for Moonlight.";
      StartLimitIntervalSec = 500;
      StartLimitBurst = 5;
    };
  };
}
