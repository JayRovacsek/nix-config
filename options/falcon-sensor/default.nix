{ config, lib, pkgs, ... }: {
  options.services.falcon = {
    enable = lib.mkOption {
      default = false;
      example = true;
      description = ''
        Whether to install Falcon Sensor from CrowdStrike.
      '';
    };
  };

  config = let
    inherit (pkgs) system coreutils;
    inherit (config.flake.outputs.packages.${system}) falcon-sensor;
    startPreScript = pkgs.writeScript "init-falcon" ''
      #!${pkgs.bash}/bin/sh
      ${coreutils}/bin/mkdir -p /opt/CrowdStrike
      ${coreutils}/bin/touch /var/log/falconctl.log
      ${coreutils}/bin/ln -sf ${falcon-sensor}/opt/CrowdStrike/* /opt/CrowdStrike
      ${falcon-sensor}/bin/fs-bash -c "${falcon-sensor}/opt/CrowdStrike/falconctl -s -f --cid=NOPE"
    '';
  in lib.mkIf config.services.falcon.enable {
    environment.persistence."/persist".directories = [ "/opt/CrowdStrike/" ];

    systemd.services.falcon-sensor = {
      enable = true;
      description = "CrowdStrike Falcon Sensor";
      unitConfig.DefaultDependencies = false;
      after = [ "local-fs.target" ];
      conflicts = [ "shutdown.target" ];
      before = [ "sysinit.target" "shutdown.target" ];
      serviceConfig = {
        ExecStartPre = "${startPreScript}";
        ExecStart = ''
          ${falcon-sensor}/bin/fs-bash -c "${falcon-sensor}/opt/CrowdStrike/falcond"
        '';
        Type = "forking";
        PIDFile = "/run/falcond.pid";
        Restart = "no";
        TimeoutStopSec = "60s";
        KillMode = "process";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
