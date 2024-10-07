{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (pkgs) system;

  server = {
    options = {
      name = lib.mkOption {
        description = "Name of the server";
        type = lib.types.str;
      };

      iconUrl = lib.mkOption {
        description = "The path to repo in local machine";
        type = lib.types.str;
      };

      address = lib.mkOption {
        description = "Address of the server";
        type = lib.types.str;
      };

      port = lib.mkOption {
        description = "Address of the server";
        type = lib.types.port;
      };
    };
  };

  cfg = config.services.bedrock-connect;
in
{
  options.services.bedrock-connect = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "If enabled, start a Bedrock Connect Server";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/bedrock-connect";
      description = ''
        Directory to store state/data files.
      '';
    };

    servers = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule server);
      default = [ ];
    };

    environment = lib.mkOption {
      type = with lib.types; attrsOf str;
      default = {
        BC_DB_TYPE = "none";
        BC_SERVER_LIMIT = "3";
        BC_PORT = builtins.toString cfg.port;
        BC_BINDIP = "0.0.0.0";
        BC_NODB = "true";
        BC_KICK_INACTIVE = "true";
        BC_CUSTOM_SERVERS = builtins.toFile "servers.json" (
          builtins.toJSON cfg.servers
        );
        BC_USER_SERVERS = "false";
        BC_FEATURED_SERVERS = "false";
        BC_FETCH_IPS = "true";
        BC_STORE_DISPLAY_NAMES = "true";
        BC_PACKET_LIMIT = "200";
        BC_GLOBAL_PACKET_LIMIT = "100000";
      };
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = self.packages.${system}.bedrock-connect;
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 19132;
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "bedrock-connect";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = cfg.user;
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedUDPPorts = lib.mkIf cfg.openFirewall [
      cfg.port
    ];

    systemd.services.bedrock-connect-server = {
      description = "Bedrock Connect Server Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      inherit (cfg) environment;

      serviceConfig = {
        ExecStart = [
          "${lib.getExe cfg.package}"
        ];
        Restart = "always";
        User = cfg.user;
        WorkingDirectory = cfg.dataDir;
      };
    };

    users = {
      groups.${cfg.group} = { };
      users.${cfg.user} = {
        inherit (cfg) group;
        description = "Bedrock Connect service user";
        isSystemUser = true;
        home = cfg.dataDir;
        createHome = true;
      };
    };
  };
}
