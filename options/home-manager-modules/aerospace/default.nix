{
  config,
  lib,
  pkgs,
  self,
  ...
}:

with lib;
let
  inherit (pkgs) stdenv system;
  inherit (self.packages.${system}) aerospace;

  cfg = config.programs.aerospace;
  tomlFormat = pkgs.formats.toml { };
in
{
  options = {
    programs.aerospace = {
      enable = mkEnableOption "an i3-like window manager for macOS";

      package = mkOption {
        type = types.package;
        default = aerospace;
        description = "The aerospace package to install.";
      };

      settings = mkOption {
        inherit (tomlFormat) type;
        default = { };
        description = "Configuration for aerospace.";
      };

      enableJankyBorders = mkOption {
        type = types.bool;
        default = true;
        description = "Enable the JankyBorders package alongside aerospace.";
      };

      jankybordersPackage = mkOption {
        type = types.package;
        default = pkgs.jankyborders;
        description = "The JankyBorders package to install.";
      };

      aerospaceAppPath = mkOption {
        type = types.str;
        default = "${cfg.package}/Applications/AeroSpace.app";
        description = "Path to the Aerospace.app bundle.";
      };

      runOnStartup = mkOption {
        type = types.bool;
        default = true;
        description = "Run AeroSpace.app on startup.";
      };
    };
  };

  config = mkIf (cfg.enable && stdenv.isDarwin) {
    home.packages = [
      cfg.package
    ] ++ lib.optional cfg.enableJankyBorders cfg.jankybordersPackage;

    xdg.configFile = {
      "aerospace/aerospace.toml" = mkIf (cfg.settings != { }) {
        source = tomlFormat.generate "config" cfg.settings;
      };
    };

    launchd.agents.aerospace = mkIf cfg.runOnStartup {
      enable = true;
      config = {
        ProgramArguments = [
          "/usr/bin/open"
          "-a"
          cfg.aerospaceAppPath
        ];
        RunAtLoad = true;
        KeepAlive = false;
        StandardOutPath = "/tmp/aerospace.log";
        StandardErrorPath = "/tmp/aerospace.error.log";
      };
    };
  };
}
