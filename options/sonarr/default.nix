{ config, lib, ... }:
let
  cfg = config.services.sonarr;
  inherit (config.flake.lib.generators) to-xml;
  inherit (lib) recursiveUpdate;
in with lib; {
  options.services.sonarr = {
    openPort = mkOption {
      type = with types; bool;
      default = cfg.openAllPorts;
      description = "";
    };

    openSslPort = mkOption {
      type = with types; bool;
      default = cfg.openAllPorts;
      description = "";
    };

    openSyslogPort = mkOption {
      type = with types; bool;
      default = cfg.openAllPorts;
      description = "";
    };

    openAllPorts = mkOption {
      type = with types; bool;
      default = false;
      description = "";
    };

    ports = {
      http = mkOption {
        type = types.port;
        default = 9999;
      };

      https = mkOption {
        type = types.port;
        default = 9898;
      };

      syslog = mkOption {
        type = types.port;
        default = 514;
      };
    };

    use-declarative-settings = mkOption {
      type = types.bool;
      default = false;
    };

    config-settings = mkOption {
      type = types.nullOr types.attrs;
      default = if cfg.use-declarative-settings then { } else null;
      description = lib.mdDoc "Config settings for Sonarr.";
    };

    logLevel = mkOption {
      type = with types; enum [ "fatal" "error" "warn" "info" "debug" ];
      default = "info";
      description = "";
    };

    authenticationMethod = mkOption {
      type = with types; enum [ "None" "Basic" "Forms" ];
      default = "None";
      description = "";
    };

    enableSsl = mkOption {
      type = with types; bool;
      default = false;
      description = "";
    };
  };

  config = mkIf cfg.enable {

    environment.etc."sonarr/config.xml" = mkIf (cfg.config-settings != null) {
      inherit (cfg) user group;
      text = let
        default-settings = import ./config-settings.nix { inherit cfg config; };
      in to-xml (recursiveUpdate default-settings cfg.config-settings);
      mode = "640";
    };

    systemd.tmpfiles.rules = [
      "L+ ${config.services.sonarr.dataDir}/config.xml - - - - /etc/sonarr/config.xml"
    ];

    # Add some smarts behind if we open any, some or all of the 
    # config ports.
    # This is a hack around the fact upstream hardcodes the port configuration
    # option as 8989
    networking.firewall = {
      allowedTCPPorts = (lib.optional cfg.openPort cfg.ports.http)
        ++ (lib.optional cfg.openSslPort cfg.ports.https);

      allowedUDPPorts = lib.optional cfg.openSyslogPort cfg.ports.syslog;
    };
  };
}
