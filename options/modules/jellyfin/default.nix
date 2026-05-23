{
  config,
  lib,
  pkgs,
  self,
  ...
}:
with lib;
let
  cfg = config.services.jellyfin;
  inherit (self.lib.generators) to-xml;
  inherit (lib) recursiveUpdate;

  defaultSystemSettings = import ./system-settings.nix { inherit config; };

  defaultNetworkSettings = import ./network-settings.nix { inherit cfg; };
  defaultNotificationSettings = import ./notification-settings.nix { };

  defaultLoggingSettings = import ./logging-settings.nix { };
in
{
  options = {
    services.jellyfin = {
      ports = {
        http = mkOption {
          type = types.port;
          default = self.common.config.services.jellyfin.port;
        };

        https = mkOption {
          type = types.port;
          default = self.common.config.services.jellyfin.https-port;
        };
      };

      metadata-dir = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          Jellyfin metadata location.
        '';
      };

      useDeclarativeSettings = mkOption {
        type = types.bool;
        default = false;
      };

      systemSettings = mkOption {
        type = types.nullOr types.attrs;
        default = lib.optionalAttrs cfg.useDeclarativeSettings defaultSystemSettings;
        description = lib.mdDoc "System settings for Jellyfin.";
      };

      network-settings = mkOption {
        type = types.nullOr types.attrs;
        default = lib.optionalAttrs cfg.useDeclarativeSettings defaultNetworkSettings;
        description = lib.mdDoc "Network settings for Jellyfin.";
      };

      notification-settings = mkOption {
        type = types.nullOr types.attrs;
        default = lib.optionalAttrs cfg.useDeclarativeSettings defaultNotificationSettings;
        description = lib.mdDoc "Notification settings for Jellyfin.";
      };

      loggingSettings = mkOption {
        type = types.nullOr types.attrs;
        default = lib.optionalAttrs cfg.useDeclarativeSettings defaultLoggingSettings;
        description = lib.mdDoc "Logging settings for Jellyfin.";
      };
    };
  };

  config = mkIf (pkgs.stdenv.isLinux && cfg.enable) {

    networking.firewall = mkIf cfg.openFirewall {
      # from https://jellyfin.org/docs/general/networking/#port-bindings
      # we've simply made the http/https options configurable via code
      allowedTCPPorts = [
        cfg.ports.http
        cfg.ports.https
      ];
    };

    systemd.services.jellyfin = {
      serviceConfig = {
        path = [ pkgs.jellyfin-ffmpeg ];
      };
    };

    environment.etc = mkIf cfg.useDeclarativeSettings {
      "jellyfin/config/network.xml" = {
        inherit (cfg) user group;
        text = to-xml (recursiveUpdate defaultNetworkSettings cfg.network-settings);
        mode = "640";
      };

      "jellyfin/config/notifications.xml" = {
        inherit (cfg) user group;
        text = to-xml (
          recursiveUpdate defaultNotificationSettings cfg.notification-settings
        );
        mode = "640";
      };

      "jellyfin/config/system.xml" = {
        inherit (cfg) user group;
        text = to-xml (recursiveUpdate defaultSystemSettings cfg.systemSettings);
        mode = "640";
      };

      "jellyfin/config/logging.default.json" = {
        inherit (cfg) user group;
        text = builtins.toJSON (
          recursiveUpdate defaultLoggingSettings cfg.loggingSettings
        );
        mode = "640";
      };
    };

    systemd.tmpfiles = mkIf cfg.useDeclarativeSettings {
      rules = [
        "L+ ${cfg.dataDir}/config/logging.default.json - - - - /etc/jellyfin/config/logging.default.json"
        "L+ ${cfg.dataDir}/config/network.xml - - - - /etc/jellyfin/config/network.xml"
        "L+ ${cfg.dataDir}/config/notifications.xml - - - - /etc/jellyfin/config/notifications.xml"
        "L+ ${cfg.dataDir}/config/system.xml - - - - /etc/jellyfin/config/system.xml"
      ];
    };
  };
}
