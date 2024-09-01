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
  CacheDirectory = "jellyfin";
  inherit (self.lib.generators) to-xml;
  inherit (lib) recursiveUpdate;
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

      data-dir = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          Jellyfin datadir location.
        '';
      };

      cache-dir = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          Jellyfin cachedir location.
        '';
      };

      metadata-dir = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          Jellyfin metadata location.
        '';
      };

      use-declarative-settings = mkOption {
        type = types.bool;
        default = false;
      };

      system-settings = mkOption {
        type = types.nullOr types.attrs;
        default = if cfg.use-declarative-settings then { } else null;
        description = lib.mdDoc "System settings for Jellyfin.";
      };

      encoding-settings = mkOption {
        type = types.nullOr types.attrs;
        default = if cfg.use-declarative-settings then { } else null;
        description = lib.mdDoc "Encoding settings for Jellyfin.";
      };

      network-settings = mkOption {
        type = types.nullOr types.attrs;
        default = if cfg.use-declarative-settings then { } else null;
        description = lib.mdDoc "Network settings for Jellyfin.";
      };

      notification-settings = mkOption {
        type = types.nullOr types.attrs;
        default = if cfg.use-declarative-settings then { } else null;
        description = lib.mdDoc "Notification settings for Jellyfin.";
      };

      logging-settings = mkOption {
        type = types.nullOr types.attrs;
        default = if cfg.use-declarative-settings then { } else null;
        description = lib.mdDoc "Logging settings for Jellyfin.";
      };

      dlna-settings = mkOption {
        type = types.nullOr types.attrs;
        default = if cfg.use-declarative-settings then { } else null;
        description = lib.mdDoc "DLNA settings for Jellyfin.";
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
      serviceConfig = rec {
        inherit CacheDirectory;
        ExecStart = lib.mkForce "${cfg.package}/bin/jellyfin --datadir '${
          if cfg.data-dir == null then "/var/lib/${CacheDirectory}" else cfg.data-dir
        }' --cachedir '${
          if cfg.cache-dir == null then "/var/cache/${CacheDirectory}" else cfg.cache-dir
        }'";
      };
    };

    environment.etc = mkIf cfg.use-declarative-settings {
      "jellyfin/config/system.xml" = mkIf (cfg.system-settings != null) {
        inherit (cfg) user group;
        text =
          let
            default-settings = import ./system-settings.nix { inherit cfg config; };
          in
          to-xml (recursiveUpdate default-settings cfg.system-settings);
        mode = "640";
      };

      "jellyfin/config/encoding.xml" = mkIf (cfg.encoding-settings != null) {
        inherit (cfg) user group;
        text =
          let
            default-settings = import ./encoding-settings.nix { inherit pkgs; };
          in
          to-xml (recursiveUpdate default-settings cfg.encoding-settings);
        mode = "640";
      };

      "jellyfin/config/network.xml" = mkIf (cfg.network-settings != null) {
        inherit (cfg) user group;
        text =
          let
            default-settings = import ./network-settings.nix { inherit cfg config; };
          in
          to-xml (recursiveUpdate default-settings cfg.network-settings);
        mode = "640";
      };

      "jellyfin/config/notifications.xml" = mkIf (cfg.notification-settings != null) {
        inherit (cfg) user group;
        text =
          let
            default-settings = import ./notification-settings.nix { inherit cfg config; };
          in
          to-xml (recursiveUpdate default-settings cfg.notification-settings);
        mode = "640";
      };

      "jellyfin/config/dlna.xml" = mkIf (cfg.dlna-settings != null) {
        inherit (cfg) user group;
        text =
          let
            default-settings = import ./dlna-settings.nix { inherit cfg config; };
          in
          to-xml (recursiveUpdate default-settings cfg.dlna-settings);
        mode = "640";
      };

      "jellyfin/config/logging.default.json" = mkIf (cfg.logging-settings != null) {
        inherit (cfg) user group;
        text =
          let
            default-settings = import ./logging-settings.nix { inherit cfg config; };
          in
          builtins.toJSON (recursiveUpdate default-settings cfg.logging-settings);
        mode = "640";
      };
    };

    systemd.tmpfiles = mkIf (cfg.logging-settings != null) {
      rules =
        let
          config-dir =
            if cfg.data-dir == null then
              "/var/lib/${CacheDirectory}/config"
            else
              "${cfg.data-dir}/config";
        in
        [
          "L+ ${config-dir}/dlna.xml - - - - /etc/jellyfin/config/dlna.xml"
          "L+ ${config-dir}/encoding.xml - - - - /etc/jellyfin/config/encoding.xml"
          "L+ ${config-dir}/logging.default.json - - - - /etc/jellyfin/config/logging.default.json"
          "L+ ${config-dir}/network.xml - - - - /etc/jellyfin/config/network.xml"
          "L+ ${config-dir}/notifications.xml - - - - /etc/jellyfin/config/notifications.xml"
          "L+ ${config-dir}/system.xml - - - - /etc/jellyfin/config/system.xml"
        ];
    };
  };
}
