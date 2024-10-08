{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.blocky;

  format = pkgs.formats.yaml { };
  configFile = format.generate "config.yaml" cfg.settings;

  requiredPackages = with pkgs; [ blocky ];
in
with lib;
{
  options = {
    services.blocky = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = mdDoc ''
          Blocky, a fast and lightweight DNS proxy as ad-blocker for local network with many features
        '';
      };
      settings = mkOption {
        inherit (format) type;
        default = { };
        description = lib.mdDoc ''
          Blocky configuration. Refer to
          <https://0xerr0r.github.io/blocky/configuration/>
          for details on supported values.
        '';
      };
      logFile = mkOption {
        type = types.nullOr types.path;
        default = "/tmp/blocky.log";
        example = "/var/log/blocky.log";
        description = ''
          The logfile to use for the blocky service.
        '';
      };
    };
  };

  config = mkIf (pkgs.stdenv.isDarwin && cfg.enable) {
    environment.systemPackages = requiredPackages;
    launchd.user.agents.blocky = {

      path = requiredPackages ++ [ config.environment.systemPath ];

      script = "${pkgs.blocky}/bin/blocky --config ${configFile}";

      serviceConfig = {
        Label = "local.blocky";
        AbandonProcessGroup = true;
        RunAtLoad = true;
        ExitTimeOut = 0;
        StandardOutPath = cfg.logFile;
        StandardErrorPath = cfg.logFile;
      };
    };
  };
}
