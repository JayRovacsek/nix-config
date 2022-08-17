{ config, pkgs, lib, ... }:
let
  cfg = config.virtualisation.docker-darwin;
  requiredPackages = with pkgs; [ colima docker ];
in with lib; {
  options = {
    virtualisation.docker-darwin = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = mdDoc ''
          This option enables docker on darwin, a daemon that manages
          linux containers. Users can interact with
          the daemon (e.g. to start or stop containers) using the
          {command}`docker` command line tool.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = requiredPackages;
    launchd.user.agents.docker = {
      path = requiredPackages;

      command =
        "${pkgs.docker}/bin/docker ps -q || ${pkgs.colima}/bin/colima start";

      serviceConfig = {
        Label = "local.docker";
        KeepAlive = false;
        ExitTimeOut = 0;
      };
    };
  };
}
