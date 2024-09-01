{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.openvscode-server;

  extensions-config = pkgs.writeTextDir "share/vscode/extensions/extensions.json" (
    pkgs.vscode-utils.toExtensionJson cfg.extensions
  );

  extensions-merged = pkgs.symlinkJoin {
    name = "extensions";
    paths = cfg.extensions ++ [ extensions-config ];
  };
in
{
  options.services.openvscode-server = {
    extensions = mkOption {
      type = types.listOf types.package;
      default = [ ];
      example = literalExpression "[ pkgs.vscode-extensions.bbenoist.nix ]";
      description = ''
        The extensions OpenVSCode Server should have globally available.
      '';
    };

    use-declarative-extensions = mkOption {
      type = types.bool;
      default = cfg.extensions != [ ];
      description = ''
        If the extensions for OpenVSCode Server should follow the declaratively
        defined options as per services.openvscode-server.extensions
      '';
    };

    settings = mkOption {
      type = types.attrs;
      default = { };
      description = ''
        The settings OpenVSCode Server should apply on the remote
      '';
    };

    use-declarative-settings = mkOption {
      type = types.bool;
      default = cfg.settings != { };
      description = ''
        If the settings for OpenVSCode Server should follow the declaratively
        defined options as per services.openvscode-server.settings
      '';
    };

    use-immutable-settings = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If settings for the server should be mutable or not
      '';
    };
  };

  config = mkIf (pkgs.stdenv.isLinux && cfg.enable) {
    environment.etc."openvscode-server/Machine/settings.json" =
      mkIf (cfg.use-declarative-settings && cfg.settings != { })
        {
          inherit (cfg) user group;
          text = builtins.toJSON cfg.settings;
          mode = if cfg.use-immutable-settings then "440" else "640";
        };

    systemd.tmpfiles.rules =
      (lib.optional cfg.use-declarative-extensions "L+ ${cfg.serverDataDir}/extensions - - - - ${extensions-merged}/share/vscode/extensions")
      ++ (lib.optional cfg.use-declarative-settings "L+ ${cfg.serverDataDir}/data/Machine/settings.json - - - - /etc/openvscode-server/Machine/settings.json");
  };
}
