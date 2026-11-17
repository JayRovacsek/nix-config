{ config, lib, ... }:
let
  inherit (lib)
    literalExpression
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.programs.skills;
  inherit (config.programs) claude-code opencode;

  mkIntegrationOption =
    name:
    mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to integrate the skills from {option}`programs.skills.skills`
        into {option}`programs.${name}.skills`.

        Note: Skills defined in {option}`programs.skills.skills` are merged
        with {option}`programs.${name}.skills`.
      '';
    };
in
{
  options.programs = {
    skills = {
      enable = mkEnableOption "skills";

      skills = mkOption {
        type = types.attrsOf (
          types.oneOf [
            types.lines
            types.path
            types.str
          ]
        );
        default = { };
        example = literalExpression ''
          {
            my-skill = ./skills/my-skill;
            inline-skill = '''
              ---
              name: inline-skill
              description: An inline skill
              ---
              Do the thing.
            ''';
          }
        '';
        description = ''
          Skills shared between agents, keyed by skill directory name.

          Each value is either inline content, a path to a file or a path to
          a directory (including Nix store paths, for example a skill
          directory from a package).
        '';
      };
    };

    claude-code.enableSkillIntegration = mkIntegrationOption "claude-code";

    opencode.enableSkillIntegration = mkIntegrationOption "opencode";
  };

  config = mkIf cfg.enable {
    programs = {
      claude-code.skills = mkIf claude-code.enableSkillIntegration cfg.skills;
      opencode.skills = mkIf opencode.enableSkillIntegration cfg.skills;
    };
  };
}
