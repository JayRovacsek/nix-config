{ config, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.programs.agent-context;
  inherit (config.programs) claude-code opencode;

  mkIntegrationOption =
    name:
    mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to integrate {option}`programs.agent-context.context` into
        {option}`programs.${name}.context`.
      '';
    };
in
{
  options.programs = {
    agent-context = {
      enable = mkEnableOption "agent-context";

      context = mkOption {
        type = types.either types.lines types.path;
        default = "";
        description = ''
          Global instructions shared between coding assistants, either inline
          content or a path to a file.
        '';
      };
    };

    claude-code.enableContextIntegration = mkIntegrationOption "claude-code";

    opencode.enableContextIntegration = mkIntegrationOption "opencode";
  };

  config = mkIf cfg.enable {
    programs = {
      claude-code.context = mkIf claude-code.enableContextIntegration cfg.context;
      opencode.context = mkIf opencode.enableContextIntegration cfg.context;
    };
  };
}
