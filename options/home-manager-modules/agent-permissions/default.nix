{ config, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.programs.agent-permissions;
  inherit (config.programs) claude-code opencode;

  actions = types.enum [
    "allow"
    "ask"
    "deny"
  ];

  mkIntegrationOption =
    name:
    mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to integrate {option}`programs.agent-permissions` into
        {option}`programs.${name}.settings`.
      '';
    };

  patternsFor = action: rules: lib.attrNames (lib.filterAttrs (_: v: v == action) rules);

  # The `*` catch-all is the opencode default action; Claude Code prompts for
  # anything unmatched, so it has no rule to translate to.
  claudeBash =
    action: map (pattern: "Bash(${pattern})") (patternsFor action (removeAttrs cfg.bash [ "*" ]));

  # Claude Code anchors absolute paths with a leading `//`.
  claudePath = pattern: if lib.hasPrefix "/" pattern then "/${pattern}" else pattern;

  claudeDirectories =
    action:
    lib.concatMap (
      pattern:
      map (tool: "${tool}(${claudePath pattern})") [
        "Read"
        "Edit"
      ]
    ) (patternsFor action cfg.externalDirectories);

  claudeRules = action: claudeBash action ++ claudeDirectories action;
in
{
  options.programs = {
    agent-permissions = {
      enable = mkEnableOption "agent-permissions";

      bash = mkOption {
        type = types.attrsOf actions;
        default = { };
        description = ''
          Bash command patterns mapped to an action, shared between coding
          assistants.

          Patterns use `*` wildcards. OpenCode applies the last matching
          pattern; Claude Code applies deny, then ask, then allow, regardless
          of order. Keep denies narrower than the allows they override so both
          behave alike. The `*` pattern sets OpenCode's default action and is
          ignored by Claude Code, which prompts for unmatched commands.
        '';
      };

      externalDirectories = mkOption {
        type = types.attrsOf actions;
        default = { };
        description = ''
          Path patterns outside the project that agents may access, mapped to
          an action. Claude Code receives them as `Read` and `Edit` rules.
        '';
      };
    };

    claude-code.enablePermissionIntegration = mkIntegrationOption "claude-code";

    opencode.enablePermissionIntegration = mkIntegrationOption "opencode";
  };

  config = mkIf cfg.enable {
    programs = {
      claude-code.settings.permissions = mkIf claude-code.enablePermissionIntegration {
        allow = claudeRules "allow";
        ask = claudeRules "ask";
        deny = claudeRules "deny";
      };

      opencode.settings.permission = mkIf opencode.enablePermissionIntegration {
        external_directory = cfg.externalDirectories;
        inherit (cfg) bash;
      };
    };
  };
}
