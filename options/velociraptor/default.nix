{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  cfg = config.services.velociraptor;
  inherit (pkgs) system;
  format = pkgs.formats.yaml { };
in
{
  options.services.velociraptor = {
    client = {
      enable = lib.mkEnableOption "Enable velociraptor in client mode";

      configuration = lib.mkOption {
        type = lib.types.attrs;
        default = import ./defaults/client-config.nix { inherit cfg; };
      };

      extraFlags = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };
    };

    server = {
      enable = lib.mkEnableOption "Enable velociraptor in server mode";

      configuration = lib.mkOption {
        type = lib.types.attrs;
        default = import ./defaults/server-config.nix { inherit cfg; };
      };

      extraFlags = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = self.packages.${system}.velociraptor;
    };
  };

  config = lib.mkIf (cfg.client.enable || cfg.server.enable) {
    networking.firewall = {
      allowedTCPPorts =
        with cfg.server.configuration;
        lib.optionals (cfg.server.enable && cfg.server.openFirewall) [
          API.bind_port
          Frontend.bind_port
          GUI.bind_port
          Monitoring.bind_port
        ];
    };

    systemd.services.velociraptor-client = lib.mkIf cfg.client.enable {
      inherit (cfg.client) enable;
      description = "Velociraptor client service";
      restartIfChanged = true;

      serviceConfig = {
        Restart = "on-failure";

        ExecStart = "${cfg.package}/bin/velociraptor client -c ${format.generate "config.yaml" cfg.client.configuration} ${lib.escapeShellArgs cfg.client.extraFlags}";
      };

      wantedBy = [ "multi-user.target" ];
    };

    systemd.services.velociraptor-server = lib.mkIf cfg.server.enable {
      inherit (cfg.server) enable;
      description = "Velociraptor server service";
      restartIfChanged = true;

      serviceConfig = {
        Restart = "on-failure";

        ExecStart = "${cfg.package}/bin/velociraptor gui -c ${format.generate "config.yaml" cfg.server.configuration} ${lib.escapeShellArgs cfg.server.extraFlags}";
      };

      wantedBy = [ "multi-user.target" ];
    };
  };
}
