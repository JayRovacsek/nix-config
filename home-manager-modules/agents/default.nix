{
  self,
  pkgs,
  ...
}:
let
  inherit (pkgs) system;

  inherit (self.packages.${system}) superpowers wshobson-agents;

  # A curated subset of the wshobson-agents collection, pinned to explicit
  # upstream artefact paths.
  #
  # Names are flattened to their `standard` form (the `<plugin>__`/`<plugin>-`
  # namespace is dropped). Where several upstream plugins ship the same base
  # artefact, a short differentiating suffix is appended so the OpenCode names
  # stay unique. This is a static list rather than a `builtins.readDir` scan so
  # evaluating the config does not force a package build (no
  # import-from-derivation).
  wshobsonAgents = {
    "ai-engineer" = "${wshobson-agents}/share/agents/llm-application-dev__ai-engineer.md";
    "bash-pro" = "${wshobson-agents}/share/agents/shell-scripting__bash-pro.md";
    "business-analyst" = "${wshobson-agents}/share/agents/business-analytics__business-analyst.md";
    "cloud-architect-cicd" = "${wshobson-agents}/share/agents/cicd-automation__cloud-architect.md";
    "cloud-architect-infra" =
      "${wshobson-agents}/share/agents/cloud-infrastructure__cloud-architect.md";
    "cloud-architect-database" =
      "${wshobson-agents}/share/agents/database-cloud-optimization__cloud-architect.md";
    "cloud-architect-deployment" =
      "${wshobson-agents}/share/agents/deployment-validation__cloud-architect.md";
    "code-reviewer-cleanup" = "${wshobson-agents}/share/agents/codebase-cleanup__code-reviewer.md";
    "code-reviewer-docs" = "${wshobson-agents}/share/agents/code-documentation__code-reviewer.md";
    "code-reviewer-refactor" = "${wshobson-agents}/share/agents/code-refactoring__code-reviewer.md";
    "code-reviewer-comprehensive" =
      "${wshobson-agents}/share/agents/comprehensive-review__code-reviewer.md";
    "code-reviewer-git-pr" = "${wshobson-agents}/share/agents/git-pr-workflows__code-reviewer.md";
    "code-reviewer-incident" = "${wshobson-agents}/share/agents/incident-response__code-reviewer.md";
    "code-reviewer-tdd" = "${wshobson-agents}/share/agents/tdd-workflows__code-reviewer.md";
    "context-manager-orchestration" =
      "${wshobson-agents}/share/agents/agent-orchestration__context-manager.md";
    "context-manager-management" =
      "${wshobson-agents}/share/agents/context-management__context-manager.md";
    "database-architect-cloud" =
      "${wshobson-agents}/share/agents/database-cloud-optimization__database-architect.md";
    "database-architect-design" =
      "${wshobson-agents}/share/agents/database-design__database-architect.md";
    "database-optimizer-cloud" =
      "${wshobson-agents}/share/agents/database-cloud-optimization__database-optimizer.md";
    "database-optimizer-migrations" =
      "${wshobson-agents}/share/agents/database-migrations__database-optimizer.md";
    "database-optimizer-observability" =
      "${wshobson-agents}/share/agents/observability-monitoring__database-optimizer.md";
    "data-engineer" = "${wshobson-agents}/share/agents/data-engineering__data-engineer.md";
    "data-scientist" = "${wshobson-agents}/share/agents/machine-learning-ops__data-scientist.md";
    "docs-architect-code" = "${wshobson-agents}/share/agents/code-documentation__docs-architect.md";
    "docs-architect-generation" =
      "${wshobson-agents}/share/agents/documentation-generation__docs-architect.md";
    "error-detective-distributed" =
      "${wshobson-agents}/share/agents/distributed-debugging__error-detective.md";
    "error-detective-debugging" = "${wshobson-agents}/share/agents/error-debugging__error-detective.md";
    "error-detective-diagnostics" =
      "${wshobson-agents}/share/agents/error-diagnostics__error-detective.md";
    "error-detective-incident" =
      "${wshobson-agents}/share/agents/incident-response__error-detective.md";
    "eval-judge" = "${wshobson-agents}/share/agents/plugin-eval__eval-judge.md";
    "eval-orchestrator" = "${wshobson-agents}/share/agents/plugin-eval__eval-orchestrator.md";
    "frontend-developer-app" =
      "${wshobson-agents}/share/agents/application-performance__frontend-developer.md";
    "frontend-developer-mobile-dev" =
      "${wshobson-agents}/share/agents/frontend-mobile-development__frontend-developer.md";
    "frontend-developer-mobile-sec" =
      "${wshobson-agents}/share/agents/frontend-mobile-security__frontend-developer.md";
    "frontend-developer-multi-platform" =
      "${wshobson-agents}/share/agents/multi-platform-apps__frontend-developer.md";
    "hr-pro" = "${wshobson-agents}/share/agents/hr-legal-compliance__hr-pro.md";
    "image-generator" = "${wshobson-agents}/share/agents/meigen-ai-design__image-generator.md";
    "legal-advisor" = "${wshobson-agents}/share/agents/hr-legal-compliance__legal-advisor.md";
    "mermaid-expert" = "${wshobson-agents}/share/agents/documentation-generation__mermaid-expert.md";
    "ml-engineer" = "${wshobson-agents}/share/agents/machine-learning-ops__ml-engineer.md";
    "mlops-engineer" = "${wshobson-agents}/share/agents/machine-learning-ops__mlops-engineer.md";
    "orchestrate" = "${wshobson-agents}/share/agents/ship-mate__orchestrate.md";
    "performance-engineer-app" =
      "${wshobson-agents}/share/agents/application-performance__performance-engineer.md";
    "performance-engineer-backend" =
      "${wshobson-agents}/share/agents/backend-development__performance-engineer.md";
    "performance-engineer-full-stack" =
      "${wshobson-agents}/share/agents/full-stack-orchestration__performance-engineer.md";
    "performance-engineer-observability" =
      "${wshobson-agents}/share/agents/observability-monitoring__performance-engineer.md";
    "performance-engineer-testing" =
      "${wshobson-agents}/share/agents/performance-testing-review__performance-engineer.md";
    "playwright" = "${wshobson-agents}/share/agents/ship-mate__playwright.md";
    "policy-enforcer" = "${wshobson-agents}/share/agents/protect-mcp__policy-enforcer.md";
    "posix-shell-pro" = "${wshobson-agents}/share/agents/shell-scripting__posix-shell-pro.md";
    "prompt-crafter" = "${wshobson-agents}/share/agents/meigen-ai-design__prompt-crafter.md";
    "prompt-engineer" = "${wshobson-agents}/share/agents/llm-application-dev__prompt-engineer.md";
    "python-pro" = "${wshobson-agents}/share/agents/python-development__python-pro.md";
    "qa" = "${wshobson-agents}/share/agents/ship-mate__qa.md";
    "review" = "${wshobson-agents}/share/agents/ship-mate__review.md";
    "review-policy-author" =
      "${wshobson-agents}/share/agents/review-agent-governance__review-policy-author.md";
    "security-auditor-backend" =
      "${wshobson-agents}/share/agents/backend-development__security-auditor.md";
    "security-auditor-comprehensive" =
      "${wshobson-agents}/share/agents/comprehensive-review__security-auditor.md";
    "security-auditor-full-stack" =
      "${wshobson-agents}/share/agents/full-stack-orchestration__security-auditor.md";
    "security-auditor-compliance" =
      "${wshobson-agents}/share/agents/security-compliance__security-auditor.md";
    "security-auditor-scanning" =
      "${wshobson-agents}/share/agents/security-scanning__security-auditor.md";
    "sql-pro" = "${wshobson-agents}/share/agents/database-design__sql-pro.md";
    "startup-analyst" = "${wshobson-agents}/share/agents/startup-business-analyst__startup-analyst.md";
    "threat-modeling-expert" =
      "${wshobson-agents}/share/agents/security-scanning__threat-modeling-expert.md";
    "typescript-pro" = "${wshobson-agents}/share/agents/javascript-typescript__typescript-pro.md";
  };

  agents =
    # Superpowers
    {
      code-reviewer = "${superpowers}/share/agents/code-reviewer.md";
    }
    # wshobson agents (curated, standard names; colliding names disambiguated)
    // wshobsonAgents
    # Local
    // {
      nix-automator = ./agents/nix-automator.md;
      product-manager = ./agents/product-manager.md;
    };
in
{
  # Imported by several agent modules; a stable key stops the module system
  # loading it once per importer.
  key = "home-manager-modules/agents";

  imports = [ ../../options/home-manager-modules/agents ];

  programs.agents = {
    enable = true;

    # Agents are assembled above from local Nix paths plus the curated
    # artefacts listed in this file, and distributed to each assistant through
    # its `enableAgentIntegration` option.
    inherit agents;
  };
}
