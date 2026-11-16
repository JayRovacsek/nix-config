{
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (pkgs) system;

  inherit (self.packages.${system}) wshobson-agents superpowers;

  wshobsonCommands = {
    "ai-assistant" = "${wshobson-agents}/share/commands/llm-application-dev__ai-assistant.md";
    "ai-review" = "${wshobson-agents}/share/commands/performance-testing-review__ai-review.md";
    "approve-review" = "${wshobson-agents}/share/commands/review-agent-governance__approve-review.md";
    "audit-chain" = "${wshobson-agents}/share/commands/protect-mcp__audit-chain.md";
    "block-no-verify" = "${wshobson-agents}/share/commands/block-no-verify__block-no-verify.md";
    "business-case" = "${wshobson-agents}/share/commands/startup-business-analyst__business-case.md";
    "code-explain" = "${wshobson-agents}/share/commands/code-documentation__code-explain.md";
    "code-migrate" = "${wshobson-agents}/share/commands/framework-migration__code-migrate.md";
    "compare" = "${wshobson-agents}/share/commands/plugin-eval__compare.md";
    "compliance-check" = "${wshobson-agents}/share/commands/security-compliance__compliance-check.md";
    "component-scaffold" =
      "${wshobson-agents}/share/commands/frontend-mobile-development__component-scaffold.md";
    "config-validate" = "${wshobson-agents}/share/commands/deployment-validation__config-validate.md";
    "context-restore-refactor" =
      "${wshobson-agents}/share/commands/code-refactoring__context-restore.md";
    "context-restore-management" =
      "${wshobson-agents}/share/commands/context-management__context-restore.md";
    "context-save" = "${wshobson-agents}/share/commands/context-management__context-save.md";
    "cost-optimize" = "${wshobson-agents}/share/commands/database-cloud-optimization__cost-optimize.md";
    "data-driven-feature" =
      "${wshobson-agents}/share/commands/data-engineering__data-driven-feature.md";
    "data-pipeline" = "${wshobson-agents}/share/commands/data-engineering__data-pipeline.md";
    "deps-audit-cleanup" = "${wshobson-agents}/share/commands/codebase-cleanup__deps-audit.md";
    "deps-audit-dependency" = "${wshobson-agents}/share/commands/dependency-management__deps-audit.md";
    "deps-upgrade" = "${wshobson-agents}/share/commands/framework-migration__deps-upgrade.md";
    "design-review" = "${wshobson-agents}/share/commands/ui-design__design-review.md";
    "doc-generate-code" = "${wshobson-agents}/share/commands/code-documentation__doc-generate.md";
    "doc-generate-generation" =
      "${wshobson-agents}/share/commands/documentation-generation__doc-generate.md";
    "error-analysis-debugging" = "${wshobson-agents}/share/commands/error-debugging__error-analysis.md";
    "error-analysis-diagnostics" =
      "${wshobson-agents}/share/commands/error-diagnostics__error-analysis.md";
    "find" = "${wshobson-agents}/share/commands/meigen-ai-design__find.md";
    "full-review" = "${wshobson-agents}/share/commands/comprehensive-review__full-review.md";
    "full-stack-feature" =
      "${wshobson-agents}/share/commands/full-stack-orchestration__full-stack-feature.md";
    "git-workflow" = "${wshobson-agents}/share/commands/git-pr-workflows__git-workflow.md";
    "improve-agent" = "${wshobson-agents}/share/commands/agent-orchestration__improve-agent.md";
    "list-pending" = "${wshobson-agents}/share/commands/review-agent-governance__list-pending.md";
    "manage" = "${wshobson-agents}/share/commands/conductor__manage.md";
    "ml-pipeline" = "${wshobson-agents}/share/commands/machine-learning-ops__ml-pipeline.md";
    "multi-agent-optimize" =
      "${wshobson-agents}/share/commands/agent-orchestration__multi-agent-optimize.md";
    "multi-agent-review-error" =
      "${wshobson-agents}/share/commands/error-debugging__multi-agent-review.md";
    "multi-agent-review-performance" =
      "${wshobson-agents}/share/commands/performance-testing-review__multi-agent-review.md";
    "multi-platform" = "${wshobson-agents}/share/commands/multi-platform-apps__multi-platform.md";
    "performance-optimization" =
      "${wshobson-agents}/share/commands/application-performance__performance-optimization.md";
    "pr-enhance-comprehensive" =
      "${wshobson-agents}/share/commands/comprehensive-review__pr-enhance.md";
    "pr-enhance-git" = "${wshobson-agents}/share/commands/git-pr-workflows__pr-enhance.md";
    "prompt-optimize" = "${wshobson-agents}/share/commands/llm-application-dev__prompt-optimize.md";
    "python-scaffold" = "${wshobson-agents}/share/commands/python-development__python-scaffold.md";
    "refactor-clean-cleanup" = "${wshobson-agents}/share/commands/codebase-cleanup__refactor-clean.md";
    "refactor-clean-refactor" = "${wshobson-agents}/share/commands/code-refactoring__refactor-clean.md";
    "slo-implement" = "${wshobson-agents}/share/commands/observability-monitoring__slo-implement.md";
    "sql-migrations" = "${wshobson-agents}/share/commands/database-migrations__sql-migrations.md";
    "typescript-scaffold" =
      "${wshobson-agents}/share/commands/javascript-typescript__typescript-scaffold.md";
    "verify-receipt" = "${wshobson-agents}/share/commands/protect-mcp__verify-receipt.md";
    "workflow-automate" = "${wshobson-agents}/share/commands/cicd-automation__workflow-automate.md";
  };

  commands =
    # Superpowers
    {
      brainstorm = "${superpowers}/share/commands/brainstorm.md";
      execute-plan = "${superpowers}/share/commands/execute-plan.md";
      write-plan = "${superpowers}/share/commands/write-plan.md";
    }
    # wshobson commands (curated, standard names; colliding names disambiguated)
    // wshobsonCommands;

  # Commands are linked via `xdg.configFile` rather than
  # `programs.opencode.commands`: Home Manager only symlinks those when the
  # value is a real Nix path (`lib.isPath`), and a packaged artefact such as
  # `"${wshobson-agents}/share/commands/x.md"` is a store-path *string*, which
  # would otherwise be written as inline file content. The `xdg.configFile`
  # file type accepts store-path strings, so it links them.
  commandFiles = lib.mapAttrs' (
    name: source: lib.nameValuePair "opencode/commands/${name}.md" { inherit source; }
  ) commands;
in
{
  imports = with self.homeManagerModules; [
    agent-context
    agent-permissions
    agents
    mcp
    skills
  ];

  xdg.configFile = commandFiles;

  programs.opencode = {
    enable = true;

    package = pkgs.opencode;

    # MCP servers, skills, agents, context and permissions are declared
    # centrally in
    # home-manager-modules/{mcp,skills,agents,agent-context,agent-permissions}.
    enableAgentIntegration = true;
    enableContextIntegration = true;
    enableMcpIntegration = true;
    enablePermissionIntegration = true;
    enableSkillIntegration = true;

    settings = {
      plugin = [
      ];

      # Only offer models from locally defined providers — GitHub Copilot
      # (built-in, authenticated via device flow) and Ollama (custom,
      # defined in home-manager-modules/ollama).
      # TODO: Make this a bit smarter on how it's built - hardcoded while testing
      provider = {
        # Served by services.halogen-flash-server (modules/halogen-flash-server),
        # which publishes the OpenAI-compatible API on hostAddress:hostPort.
        # TODO: Correct this to leverage common config options, expose only over tailscale or alike
        halogen-server = {
          npm = "@ai-sdk/openai-compatible";
          name = "halogen-server";
          options = {
            baseURL = "http://127.0.0.1:11435/v1";
          };
          models = {
            # https://huggingface.co/peonist-ai/halogen-qwen3.8-flash-next
            # curl -sS http://localhost:11435/v1/models | jq -r '.data[].id'
            "halogen-qwen3.8-flash-next" = {
              name = "halogen-qwen3.8-flash-next";
              limit = {
                context = 262144;
                output = 65536;
              };
              modalities = {
                input = [
                  "text"
                  "image"
                ];
                output = [ "text" ];
              };
            };
          };
        };
      };

      lsp.nixd = {
        command = [ "${pkgs.nixd}/bin/nixd" ];
        extensions = [ ".nix" ];
        configuration.nixd = {
          formatting.command = [ "nixfmt" ];
          options.enable = true;
        };
      };
    };
  };
}
