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

      path = requiredPackages ++ [ config.environment.systemPath ];

      # Script logic is:
      # check if docker ps gives a zero exit code, if not use `colima start`
      # but guard this also from unclean stops by assuming in another non
      # zero exit that a qemu host exists/is running but host side is borked
      # and pkill the pid if so.

      # Then check colima status, if default (normal colima namespace with start)
      # has a non-zero exit (i.e not running) start it.
      script = ''
        ${pkgs.docker}/bin/docker ps -q || ${pkgs.colima}/bin/colima start || pkill -F ~/.lima/colima/qemu.pid 
        ${pkgs.colima}/bin/colima status -p default || ${pkgs.colima}/bin/colima start default 
      '';

      serviceConfig = {
        Label = "local.docker";
        KeepAlive = true;
        RunAtLoad = true;
        ExitTimeOut = 0;
      };
    };
  };
}
