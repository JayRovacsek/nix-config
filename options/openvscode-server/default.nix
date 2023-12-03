{ config, lib, pkgs, ... }:
with lib;
let
  inherit (pkgs.vscode-utils) toExtensionJson;

  cfg = config.services.openvscode-server;

  extensions-config =
    pkgs.writeTextDir "share/vscode/extensions/extensions.json"
    (pkgs.vscode-utils.toExtensionJson cfg.extensions);

  extensions-merged = pkgs.symlinkJoin {
    name = "extensions";
    paths = cfg.extensions ++ [ extensions-config ];
  };
in {
  options.services.openvscode-server = {
    extensions = mkOption {
      type = types.listOf types.package;
      default = [ ];
      example = literalExpression "[ pkgs.vscode-extensions.bbenoist.nix ]";
      description = ''
        The extensions OpenVSCode Server should have globally available.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "L+ ${cfg.serverDataDir}/extensions - - - - ${extensions-merged}/share/vscode/extensions"
    ];
  };
}
