{ config, lib, osConfig, pkgs, ... }:
let
  inherit (config.xdg) configHome;

  nvidia-present = builtins.any (driver: driver == "nvidia")
    osConfig.services.xserver.videoDrivers;

  cfg = {
    address_family = "ipv4";
    encoder = lib.optionalString nvidia-present "nvenc";
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
    env.PATH = config.home.path;

    apps = [
      {
        name = "Desktop";
        image-path = "desktop.png";
      }
      {
        name = "Steam Big Picture";
        detached = [
          "${pkgs.util-linux}/bin/setsid ${pkgs.steam}/bin/steam steam=//open/bigpicture"
        ];
        # TODO: correct the image to be reproducible via a derivation
        image-path = "steam.png";
      }
      {
        name = "Codium";
        output = "";
        cmd = "${pkgs.vscodium}/bin/codium";
        exclude-global-prep-cmd = false;
        elevated = false;
        auto-detach = true;
        # TODO: correct the image to be reproducible via a derivation
        image-path = "";
        working-dir = "~/dev/personal/nix-config";
      }
      {
        name = "Firefox";
        output = "";
        cmd = "${pkgs.firefox}/bin/firefox";
        exclude-global-prep-cmd = false;
        elevated = false;
        auto-detach = true;
        # TODO: correct the image to be reproducible via a derivation
        image-path = "";
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
