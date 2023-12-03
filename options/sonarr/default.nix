{ config, lib, ... }:
let cfg = config.services.sonarr;
in with lib; {
  options.services.sonarr = {
    openPort = mkOption {
      type = with types; bool;
      default = false;
      description = "";
    };

    openSslPort = mkOption {
      type = with types; bool;
      default = false;
      description = "";
    };

    openAllPorts = mkOption {
      type = with types; bool;
      default = false;
      description = "";
    };

    port = mkOption {
      type = with types; int;
      default = 8989;
      description = "";
    };

    sslPort = mkOption {
      type = with types; int;
      default = 9898;
      description = "";
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
    # Add some smarts behind if we open any, some or all of the 
    # config ports.
    # This is a hack around the fact upstream hardcodes the port configuration
    # option as 8989
    networking.firewall = mkIf
      (builtins.any (x: x) [ cfg.openPort cfg.openSslPort cfg.openAllPorts ]) {
        allowedTCPPorts = if cfg.openAllPorts then [
          cfg.port
          cfg.sslPort
        ] else
          (lib.optional cfg.openPort cfg.port)
          ++ (lib.optional cfg.openSslPort cfg.sslPort);
      };
  };
}
