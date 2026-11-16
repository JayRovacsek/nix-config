{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    literalExpression
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.programs.agents;
  inherit (config.programs) claude-code opencode;

  mkIntegrationOption =
    name:
    mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to integrate the agents from {option}`programs.agents.agents`
        into {option}`programs.${name}.agents`.

        Note: Agents defined in {option}`programs.agents.agents` are merged
        with {option}`programs.${name}.agents`.
      '';
    };
in
{
  options.programs = {
    agents = {
      enable = mkEnableOption "agents";

      agents = mkOption {
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
            code-reviewer = ./agents/code-reviewer.md;
            inline-agent = '''
              ---
              description: An inline agent
              ---
              Do the thing.
            ''';
          }
        '';
        description = ''
          Agents shared between coding assistants, keyed by agent name
          (without the `.md` suffix).

          Each value is either inline content or a path to a file, including
          Nix store paths such as an agent file from a package.
        '';
      };
    };

    claude-code.enableAgentIntegration = mkIntegrationOption "claude-code";

    opencode.enableAgentIntegration = mkIntegrationOption "opencode";
  };

  config = mkIf cfg.enable {
    programs.claude-code.agents = mkIf claude-code.enableAgentIntegration cfg.agents;

    # Home Manager only symlinks `programs.opencode.agents` entries when the
    # value is a real Nix path (`lib.isPath`); a packaged artefact such as
    # `"${pkgs.foo}/share/agents/x.md"` is a store-path *string* and would be
    # written as inline file content. The `xdg.configFile` file type accepts
    # store-path strings, so link them there instead.
    xdg.configFile = mkIf opencode.enableAgentIntegration (
      lib.mapAttrs' (
        name: source: lib.nameValuePair "opencode/agents/${name}.md" { inherit source; }
      ) cfg.agents
    );
  };
}
