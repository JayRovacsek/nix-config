{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.dragonwilds-server;
in
{
  options.services.dragonwilds-server = {
    enable = lib.mkEnableOption "Dragonwilds Dedicated Server";

    steamcmdPackage = lib.mkOption {
      type = lib.types.package;
      default = pkgs.steamcmd;
      defaultText = "pkgs.steamcmd";
      description = ''
        The package implementing SteamCMD
      '';
    };

    gameID = lib.mkOption {
      type = lib.types.int;
      description = "gameID";
      default = 4019830;
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      description = "Directory to store game server";
      default = "/var/lib/dragonwilds";
    };

    backupDir = lib.mkOption {
      type = lib.types.path;
      description = "Directory to store config backups";
      default = "${cfg.dataDir}/dragonwilds_backups";
    };

    serverConfig = lib.mkOption {
      type = lib.types.path;
      description = ''
        Path to the server configuration file used to seed the server's
        config on first start. This is a path so that sensitive values can
        be managed via agenix, e.g. config.age.secrets.<name>.path. Ensure
        the path is readable by the dragonwilds user.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      description = "TCP/UDP port for the server";
      default = 7777;
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to open ports in the firewall for the server
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.dragonwilds-server =
      let
        steamcmd = lib.getExe cfg.steamcmdPackage;
        mkdir = lib.getExe' pkgs.coreutils "mkdir";
        chmod = lib.getExe' pkgs.coreutils "chmod";
        install = lib.getExe' pkgs.coreutils "install";
        steamRun = "${pkgs.steam-run}/bin/steam-run";

        runtimeConfig = "${cfg.dataDir}/RSDragonwilds/Saved/Config/LinuxServer/DedicatedServer.ini";

        initialiseConfig = pkgs.writeShellScript "dragonwilds-init-config" ''
          if [ ! -f "${runtimeConfig}" ]; then
            ${install} -m0644 "${cfg.serverConfig}" "${runtimeConfig}"
          fi
        '';
      in
      {
        description = "RuneScape Dragonwilds Dedicated Server";
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];

        serviceConfig = {
          Type = "simple";
          User = "dragonwilds";
          Group = "dragonwilds";
          WorkingDirectory = cfg.dataDir;
          Restart = "always";
          RestartSec = 15;

          ExecStartPre = [
            "${mkdir} -p ${cfg.dataDir}"
            "${mkdir} -p ${cfg.dataDir}/RSDragonwilds/Saved/Config/LinuxServer"
            "${mkdir} -p ${cfg.backupDir}"

            "${steamcmd} +force_install_dir ${cfg.dataDir} +login anonymous +app_update ${toString cfg.gameID} +quit"

            # Seed the config if it doesn't exist.
            initialiseConfig

            "${chmod} +x ${cfg.dataDir}/RSDragonwildsServer.sh"
          ];

          ExecStart = "${steamRun} ${cfg.dataDir}/RSDragonwildsServer.sh -log -NewConsole -Port=${toString cfg.port}";
        };
      };

    users.users.dragonwilds = {
      description = "Dragonwilds server service user";
      home = cfg.dataDir;
      createHome = true;
      isSystemUser = true;
      group = "dragonwilds";
    };

    users.groups.dragonwilds = { };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [
        cfg.port
      ];
      allowedUDPPorts = [
        cfg.port
      ];
    };
  };
}
