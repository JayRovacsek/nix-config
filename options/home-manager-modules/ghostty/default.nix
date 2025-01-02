{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  cfg = config.programs.ghostty;
in
{
  options = {
    programs.ghostty = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.ghostty;
      };

      settings = lib.mkOption {
        type = lib.types.attrs;
        default = { };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile = {
      "ghostty/config" = lib.mkIf (cfg.settings != { }) {
        text = self.lib.generators.to-ghostty cfg.settings;
      };
    };
  };
}
