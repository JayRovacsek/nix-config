{
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (pkgs) system;

  inherit (self.packages.${system})
    anthropic-skills
    dbt-agent-skills
    rea
    wshobson-agents
    superpowers
    ;

  mkMcpServer =
    {
      name,
      flakeRef ? null,
      command ? null,
      url ? null,
      args ? [ ],
      env ? { },
      headers ? { }, # HTTP headers for remote MCP servers (e.g., Authorization)
    }:
    let
      hasFlakeRef = flakeRef != null;
      hasCommand = command != null;
      hasUrl = url != null;

      localBase =
        if hasFlakeRef then
          {
            type = "local";
            command = [
              "nix"
              "run"
              flakeRef
              "--"
            ]
            ++ args;
          }
        else
          {
            type = "local";
            command = command ++ args;
          };

      remoteBase = {
        type = "remote";
        inherit url;
      };

      base = if hasUrl then remoteBase else localBase;

      # Only include env/headers when non-empty
      envAttr = lib.optionalAttrs (env != { }) { inherit env; };
      headersAttr = lib.optionalAttrs (headers != { }) { inherit headers; };
    in
    assert lib.assertMsg (
      (lib.count (x: x) [
        hasFlakeRef
        hasCommand
        hasUrl
      ]) == 1
    ) "mkMcpServer '${name}': exactly one of flakeRef, command, or url must be set";
    assert lib.assertMsg (
      !(hasUrl && args != [ ])
    ) "mkMcpServer '${name}': 'args' cannot be used with remote 'url' servers";
    assert lib.assertMsg (
      !(!hasUrl && headers != { })
    ) "mkMcpServer '${name}': 'headers' can only be used with remote 'url' servers";
    {
      ${name} = base // envAttr // headersAttr;
    };

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
  wshobsonSkills = {
    "backend-development-api-design-principles" =
      "${wshobson-agents}/share/skills/backend-development-api-design-principles";
    "documentation-generation-architecture-decision-records" =
      "${wshobson-agents}/share/skills/documentation-generation-architecture-decision-records";
    "backend-development-architecture-patterns" =
      "${wshobson-agents}/share/skills/backend-development-architecture-patterns";
    "python-development-async-python-patterns" =
      "${wshobson-agents}/share/skills/python-development-async-python-patterns";
    "shell-scripting-bash-defensive-patterns" =
      "${wshobson-agents}/share/skills/shell-scripting-bash-defensive-patterns";
    "shell-scripting-bats-testing-patterns" =
      "${wshobson-agents}/share/skills/shell-scripting-bats-testing-patterns";
    "payment-processing-billing-automation" =
      "${wshobson-agents}/share/skills/payment-processing-billing-automation";
    "reverse-engineering-binary-analysis-patterns" =
      "${wshobson-agents}/share/skills/reverse-engineering-binary-analysis-patterns";
    "block-no-verify-block-no-verify-hook" =
      "${wshobson-agents}/share/skills/block-no-verify-block-no-verify-hook";
    "documentation-generation-changelog-automation" =
      "${wshobson-agents}/share/skills/documentation-generation-changelog-automation";
    "developer-essentials-code-review-excellence" =
      "${wshobson-agents}/share/skills/developer-essentials-code-review-excellence";
    "conductor-context-driven-development" =
      "${wshobson-agents}/share/skills/conductor-context-driven-development";
    "cloud-infrastructure-cost-optimization" =
      "${wshobson-agents}/share/skills/cloud-infrastructure-cost-optimization";
    "framework-migration-database-migration" =
      "${wshobson-agents}/share/skills/framework-migration-database-migration";
    "data-engineering-data-quality-frameworks" =
      "${wshobson-agents}/share/skills/data-engineering-data-quality-frameworks";
    "business-analytics-data-storytelling" =
      "${wshobson-agents}/share/skills/business-analytics-data-storytelling";
    "data-engineering-dbt-transformation-patterns" =
      "${wshobson-agents}/share/skills/data-engineering-dbt-transformation-patterns";
    "developer-essentials-debugging-strategies" =
      "${wshobson-agents}/share/skills/developer-essentials-debugging-strategies";
    "framework-migration-dependency-upgrade" =
      "${wshobson-agents}/share/skills/framework-migration-dependency-upgrade";
    "cicd-automation-deployment-pipeline-design" =
      "${wshobson-agents}/share/skills/cicd-automation-deployment-pipeline-design";
    "ui-design-design-system-patterns" =
      "${wshobson-agents}/share/skills/ui-design-design-system-patterns";
    "developer-essentials-error-handling-patterns" =
      "${wshobson-agents}/share/skills/developer-essentials-error-handling-patterns";
    "plugin-eval-evaluation-methodology" =
      "${wshobson-agents}/share/skills/plugin-eval-evaluation-methodology";
    "backend-development-event-store-design" =
      "${wshobson-agents}/share/skills/backend-development-event-store-design";
    "hr-legal-compliance-gdpr-data-handling" =
      "${wshobson-agents}/share/skills/hr-legal-compliance-gdpr-data-handling";
    "developer-essentials-git-advanced-workflows" =
      "${wshobson-agents}/share/skills/developer-essentials-git-advanced-workflows";
    "cicd-automation-github-actions-templates" =
      "${wshobson-agents}/share/skills/cicd-automation-github-actions-templates";
    "kubernetes-operations-gitops-workflow" =
      "${wshobson-agents}/share/skills/kubernetes-operations-gitops-workflow";
    "game-development-godot-gdscript-patterns" =
      "${wshobson-agents}/share/skills/game-development-godot-gdscript-patterns";
    "observability-monitoring-grafana-dashboards" =
      "${wshobson-agents}/share/skills/observability-monitoring-grafana-dashboards";
    "ui-design-interaction-design" = "${wshobson-agents}/share/skills/ui-design-interaction-design";
    "javascript-typescript-javascript-testing-patterns" =
      "${wshobson-agents}/share/skills/javascript-typescript-javascript-testing-patterns";
    "business-analytics-kpi-dashboard-design" =
      "${wshobson-agents}/share/skills/business-analytics-kpi-dashboard-design";
    "cloud-infrastructure-linkerd-patterns" =
      "${wshobson-agents}/share/skills/cloud-infrastructure-linkerd-patterns";
    "llm-application-dev-llm-evaluation" =
      "${wshobson-agents}/share/skills/llm-application-dev-llm-evaluation";
    "startup-business-analyst-market-sizing-analysis" =
      "${wshobson-agents}/share/skills/startup-business-analyst-market-sizing-analysis";
    "machine-learning-ops-ml-pipeline-workflow" =
      "${wshobson-agents}/share/skills/machine-learning-ops-ml-pipeline-workflow";
    "javascript-typescript-modern-javascript-patterns" =
      "${wshobson-agents}/share/skills/javascript-typescript-modern-javascript-patterns";
    "cloud-infrastructure-multi-cloud-architecture" =
      "${wshobson-agents}/share/skills/cloud-infrastructure-multi-cloud-architecture";
    "agent-teams-multi-reviewer-patterns" =
      "${wshobson-agents}/share/skills/agent-teams-multi-reviewer-patterns";
    "javascript-typescript-nodejs-backend-patterns" =
      "${wshobson-agents}/share/skills/javascript-typescript-nodejs-backend-patterns";
    "agent-teams-parallel-debugging" = "${wshobson-agents}/share/skills/agent-teams-parallel-debugging";
    "agent-teams-parallel-feature-development" =
      "${wshobson-agents}/share/skills/agent-teams-parallel-feature-development";
    "payment-processing-pci-compliance" =
      "${wshobson-agents}/share/skills/payment-processing-pci-compliance";
    "llm-application-dev-prompt-engineering-patterns" =
      "${wshobson-agents}/share/skills/llm-application-dev-prompt-engineering-patterns";
    "protect-mcp-protect-mcp-setup" = "${wshobson-agents}/share/skills/protect-mcp-protect-mcp-setup";
    "python-development-python-anti-patterns" =
      "${wshobson-agents}/share/skills/python-development-python-anti-patterns";
    "python-development-python-background-jobs" =
      "${wshobson-agents}/share/skills/python-development-python-background-jobs";
    "python-development-python-code-style" =
      "${wshobson-agents}/share/skills/python-development-python-code-style";
    "python-development-python-configuration" =
      "${wshobson-agents}/share/skills/python-development-python-configuration";
    "python-development-python-design-patterns" =
      "${wshobson-agents}/share/skills/python-development-python-design-patterns";
    "python-development-python-error-handling" =
      "${wshobson-agents}/share/skills/python-development-python-error-handling";
    "python-development-python-observability" =
      "${wshobson-agents}/share/skills/python-development-python-observability";
    "python-development-python-packaging" =
      "${wshobson-agents}/share/skills/python-development-python-packaging";
    "python-development-python-performance-optimization" =
      "${wshobson-agents}/share/skills/python-development-python-performance-optimization";
    "python-development-python-project-structure" =
      "${wshobson-agents}/share/skills/python-development-python-project-structure";
    "python-development-python-resilience" =
      "${wshobson-agents}/share/skills/python-development-python-resilience";
    "python-development-python-resource-management" =
      "${wshobson-agents}/share/skills/python-development-python-resource-management";
    "python-development-python-testing-patterns" =
      "${wshobson-agents}/share/skills/python-development-python-testing-patterns";
    "python-development-python-type-safety" =
      "${wshobson-agents}/share/skills/python-development-python-type-safety";
    "llm-application-dev-rag-implementation" =
      "${wshobson-agents}/share/skills/llm-application-dev-rag-implementation";
    "review-agent-governance-review-agent-setup" =
      "${wshobson-agents}/share/skills/review-agent-governance-review-agent-setup";
    "quantitative-trading-risk-metrics-calculation" =
      "${wshobson-agents}/share/skills/quantitative-trading-risk-metrics-calculation";
    "cicd-automation-secrets-management" =
      "${wshobson-agents}/share/skills/cicd-automation-secrets-management";
    "security-scanning-security-requirement-extraction" =
      "${wshobson-agents}/share/skills/security-scanning-security-requirement-extraction";
    "cloud-infrastructure-service-mesh-observability" =
      "${wshobson-agents}/share/skills/cloud-infrastructure-service-mesh-observability";
    "shell-scripting-shellcheck-configuration" =
      "${wshobson-agents}/share/skills/shell-scripting-shellcheck-configuration";
    "signed-audit-trails-signed-audit-trails-recipe" =
      "${wshobson-agents}/share/skills/signed-audit-trails-signed-audit-trails-recipe";
    "llm-application-dev-similarity-search-patterns" =
      "${wshobson-agents}/share/skills/llm-application-dev-similarity-search-patterns";
    "observability-monitoring-slo-implementation" =
      "${wshobson-agents}/share/skills/observability-monitoring-slo-implementation";
    "developer-essentials-sql-optimization-patterns" =
      "${wshobson-agents}/share/skills/developer-essentials-sql-optimization-patterns";
    "security-scanning-stride-analysis-patterns" =
      "${wshobson-agents}/share/skills/security-scanning-stride-analysis-patterns";
    "agent-teams-task-coordination-strategies" =
      "${wshobson-agents}/share/skills/agent-teams-task-coordination-strategies";
    "security-scanning-threat-mitigation-mapping" =
      "${wshobson-agents}/share/skills/security-scanning-threat-mitigation-mapping";
    "javascript-typescript-typescript-advanced-types" =
      "${wshobson-agents}/share/skills/javascript-typescript-typescript-advanced-types";
    "python-development-uv-package-manager" =
      "${wshobson-agents}/share/skills/python-development-uv-package-manager";
    "llm-application-dev-vector-index-tuning" =
      "${wshobson-agents}/share/skills/llm-application-dev-vector-index-tuning";
    "backend-development-workflow-orchestration-patterns" =
      "${wshobson-agents}/share/skills/backend-development-workflow-orchestration-patterns";
  };
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

  skills =
    # Superpowers
    {
      brainstorming = "${superpowers}/share/skills/brainstorming";
      dispatching-parallel-agents = "${superpowers}/share/skills/dispatching-parallel-agents";
      executing-plans = "${superpowers}/share/skills/executing-plans";
      finishing-a-development-branch = "${superpowers}/share/skills/finishing-a-development-branch";
      receiving-code-review = "${superpowers}/share/skills/receiving-code-review";
      requesting-code-review = "${superpowers}/share/skills/requesting-code-review";
      subagent-driven-development = "${superpowers}/share/skills/subagent-driven-development";
      systematic-debugging = "${superpowers}/share/skills/systematic-debugging";
      test-driven-development = "${superpowers}/share/skills/test-driven-development";
      using-git-worktrees = "${superpowers}/share/skills/using-git-worktrees";
      using-superpowers = "${superpowers}/share/skills/using-superpowers";
      verification-before-completion = "${superpowers}/share/skills/verification-before-completion";
      writing-plans = "${superpowers}/share/skills/writing-plans";
      writing-skills = "${superpowers}/share/skills/writing-skills";
    }
    # Anthropic
    // {
      algorithmic-art = "${anthropic-skills}/share/skills/algorithmic-art";
      canvas-design = "${anthropic-skills}/share/skills/canvas-design";
      doc-coauthoring = "${anthropic-skills}/share/skills/doc-coauthoring";
      docx = "${anthropic-skills}/share/skills/docx";
      frontend-design = "${anthropic-skills}/share/skills/frontend-design";
      internal-comms = "${anthropic-skills}/share/skills/internal-comms";
      mcp-builder = "${anthropic-skills}/share/skills/mcp-builder";
      pdf = "${anthropic-skills}/share/skills/pdf";
      pptx = "${anthropic-skills}/share/skills/pptx";
      skill-creator = "${anthropic-skills}/share/skills/skill-creator";
      slack-gif-creator = "${anthropic-skills}/share/skills/slack-gif-creator";
      theme-factory = "${anthropic-skills}/share/skills/theme-factory";
      web-artifacts-builder = "${anthropic-skills}/share/skills/web-artifacts-builder";
      webapp-testing = "${anthropic-skills}/share/skills/webapp-testing";
      xlsx = "${anthropic-skills}/share/skills/xlsx";
    }
    # DBT
    // {
      adding-dbt-unit-test = "${dbt-agent-skills}/share/skills/adding-dbt-unit-test";
      answering-natural-language-questions-with-dbt = "${dbt-agent-skills}/share/skills/answering-natural-language-questions-with-dbt";
      building-dbt-semantic-layer = "${dbt-agent-skills}/share/skills/building-dbt-semantic-layer";
      configuring-dbt-mcp-server = "${dbt-agent-skills}/share/skills/configuring-dbt-mcp-server";
      fetching-dbt-docs = "${dbt-agent-skills}/share/skills/fetching-dbt-docs";
      migrating-dbt-core-to-fusion = "${dbt-agent-skills}/share/skills/migrating-dbt-core-to-fusion";
      running-dbt-commands = "${dbt-agent-skills}/share/skills/running-dbt-commands";
      troubleshooting-dbt-job-errors = "${dbt-agent-skills}/share/skills/troubleshooting-dbt-job-errors";
      using-dbt-for-analytics-engineering = "${dbt-agent-skills}/share/skills/using-dbt-for-analytics-engineering";
    }
    # REA (Reverse Engineer Anything) — the full upstream skill suite:
    # the published `skills/` artefact plus the auxiliary skills that
    # upstream keeps under `.agents/skills/` (see packages/other/rea).
    // {
      reverse-engineer-anything = "${rea}/lib/node_modules/rea-agents/skills/reverse-engineer-anything";
      rea-analysis-optimization = "${rea}/lib/node_modules/rea-agents/.agents/skills/rea-analysis-optimization";
      rea-changelog-update = "${rea}/lib/node_modules/rea-agents/.agents/skills/rea-changelog-update";
      rea-ci-tests-audit = "${rea}/lib/node_modules/rea-agents/.agents/skills/rea-ci-tests-audit";
      rea-tool-design = "${rea}/lib/node_modules/rea-agents/.agents/skills/rea-tool-design";
    }
    // wshobsonSkills
    # Local
    // {
      market-research = ./skills/market-research;
      nix-ops = ./skills/nix-ops;
      nixos-test-dev = ./skills/nixos-test-dev;
      product-management = ./skills/product-management;
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

  # Agents and commands are linked via `xdg.configFile` rather than
  # `programs.opencode.agents`/`commands`: Home Manager only symlinks those
  # when the value is a real Nix path (`lib.isPath`), and a packaged artefact
  # such as `"${wshobson-agents}/share/agents/x.md"` is a store-path *string*,
  # which would otherwise be written as inline file content. The
  # `xdg.configFile` file type accepts store-path strings, so it links them.
  agentFiles = lib.mapAttrs' (
    name: source: lib.nameValuePair "opencode/agents/${name}.md" { inherit source; }
  ) agents;
  commandFiles = lib.mapAttrs' (
    name: source: lib.nameValuePair "opencode/commands/${name}.md" { inherit source; }
  ) commands;

  # ---------------------------------------------------------------------------
  # MCP server declarations
  #
  # Each mkMcpServer call produces { name = { type, command|url, ... }; }
  # We merge them all into a single attrset for programs.opencode.settings.mcp
  # ---------------------------------------------------------------------------

  mcp = lib.mergeAttrsList [
    # NixOS/Home Manager/nix-darwin package & option search
    (mkMcpServer {
      name = "nixos";
      flakeRef = "github:utensils/mcp-nixos";
    })

    # Grafana: dashboards, datasources, Prometheus/Loki queries, alerting.
    # https://github.com/grafana/mcp-grafana
    # Requires GRAFANA_URL and GRAFANA_SERVICE_ACCOUNT_TOKEN in the
    # environment at runtime.
    (mkMcpServer {
      name = "grafana";
      command = [ "${pkgs.mcp-grafana}/bin/mcp-grafana" ];
    })

    # Up-to-date library documentation from context7.com.
    # https://github.com/upstash/context7
    # Optional CONTEXT7_API_KEY in the environment for higher rate limits.
    (mkMcpServer {
      name = "context7";
      command = [ "${pkgs.context7-mcp}/bin/context7-mcp" ];
    })

    # Firefox DevTools automation via WebDriver BiDi: page navigation, DOM
    # snapshots, console and network inspection.
    # https://github.com/mozilla/firefox-devtools-mcp
    # Auto-detects a `firefox` binary on PATH at runtime (provided by the
    # desktop home package set).
    (mkMcpServer {
      name = "firefox-devtools";
      command = [ "${pkgs.firefox-devtools-mcp}/bin/firefox-devtools-mcp" ];
    })

    # REA — Reverse Engineer Anything: MCP server for reverse engineering
    # native binaries, managed assemblies, JavaScript/Electron apps and
    # more. https://github.com/morluto/rea (packaged in packages/other/rea)
    (mkMcpServer {
      name = "rea";
      command = [ "${rea}/bin/rea" ];
      args = [ "mcp" ];
    })

    (mkMcpServer {
      name = "atlassian";
      url = "https://mcp.atlassian.com/v1/mcp";
    })
  ];
in
{
  xdg.configFile = agentFiles // commandFiles;

  programs.opencode = {
    enable = true;

    package = pkgs.opencode;

    # `skills` are assembled above from local Nix paths plus the curated
    # artefacts listed in this file. Skills accept store-path strings because
    # Home Manager special-cases them (via `isPathLike`).
    inherit skills;

    # Global agent instructions written to $XDG_CONFIG_HOME/opencode/AGENTS.md.
    # All agents automatically receive this content as baseline context.
    #
    # Commit policy references:
    #   - Conventional Commits: https://www.conventionalcommits.org
    #   - Assisted-by footer: https://xeiaso.net/notes/2025/assisted-by-footer/
    #   - Conform config: packages/text/conform-config/default.nix
    #   - Git-cliff config: packages/text/git-cliff-config/default.nix
    context = ''
      # Repository Guidelines

      **All AI agents MUST comply with every rule in this document.**

      ## Core Principles

      1. **Keep code as simple as possible.** Prefer clarity over cleverness.
         Avoid unnecessary abstractions, indirection, or premature generalisation.
         Every line should earn its place.
      2. **After making any code changes, delegate to a `code-review` agent to
         review the changes before considering the task complete.** Do not skip
         this step, unless the change is a small modification.
      3. **Always ask qualifying questions before and during a task** to ensure
         you fully understand the requirements and constraints. Do not assume
         intent — clarify ambiguities, confirm assumptions, and seek feedback
         at each significant decision point. Only skip questions if the user
         explicitly tells you not to ask.
      4. **Use Australian English (EN-AU) spelling** in all prose: commit
         messages, code comments, documentation, and agent output. This
         means "colour", "organisation", "categorise", "analyse",
         "behaviour", etc. The only exceptions are identifiers required by
         code — HTTP headers (`Authorization`), API field names, library
         symbols, and similar technical tokens where US spelling is part of
         a protocol or specification.

      ## Execution Model: Parallel Orchestration

      All tasks MUST be executed with maximum parallelism unless the user
      explicitly requests sequential execution.

      ### Delegation Rules

      1. **Root-level agents are orchestrators, not implementers.** When you
         are the top-level (root) agent in a conversation, your role is to
         decompose work, select the best-fit specialist agent for each
         sub-task, and spawn those agents in parallel. Do NOT implement
         work yourself unless no suitable specialist agent exists or you
         are already operating as a subagent.
      2. **Agent selection is mandatory.** For every discrete sub-task, assess
         which available agent persona is the most suitable (e.g.,
         `nix-automator` for Nix changes, `code-reviewer` for reviews,
         `security-auditor` for security, etc.) and delegate to it. Never
         default to doing the work in-process when a specialist is available.
      3. **Subagents implement directly.** If you have been spawned as a
         subagent (i.e., you are not the root-level instance), you MUST
         do the work yourself rather than spawning further subagents,
         unless the task genuinely requires a different specialism.
      4. **Maximise concurrency.** Independent sub-tasks MUST be dispatched
         simultaneously, not sequentially. Only serialise tasks that have
         true data dependencies on one another.
      5. **Recombine and verify.** After all parallel sub-tasks complete,
         the orchestrator must review, reconcile, and verify the combined
         results before reporting back to the user.

      ## Skill & Tool Selection

      Before beginning any task, **always** check the list of available
      skills and tools. If a skill closely matches the task at hand, load
      and follow it — this is a strong preference, not optional. Skills
      encode domain-specific workflows, templates, and best practices that
      produce higher quality results than ad-hoc reasoning. Only skip
      loading a skill when no available skill is a reasonable fit for the
      work being done.

      ## Extension Supply Chain Policy

      All OpenCode extensions — agents, skills, commands, plugins, and MCP
      servers — are **declaratively managed via Nix configuration** in this
      repository. The following rules are non-negotiable:

      ### Immutability

      1. Extensions MUST be pinned to a **static upstream revision** (commit
         hash, tag, or content hash). Floating references (branches, `latest`
         tags, unpinned URLs) are forbidden.
      2. Extensions MUST NOT update, modify, or reinstall themselves at
         runtime. All changes flow through a configuration update, rebuild,
         and activation cycle.
      3. Never edit extension files on disk directly (e.g., under
         `$XDG_CONFIG_HOME/opencode/`). Those paths are managed by
         Home Manager and will be overwritten on the next activation.

      ### Vetting New Sources

      Before adding any new upstream source (GitHub repo, flake input, MCP
      server, etc.) to the OpenCode configuration:

      1. **Review the source repository** for signs of malicious or
         untrustworthy content — check commit history, maintainer
         reputation, open issues, and license.
      2. **Read every agent/skill/command file** that will be imported.
         Pay special attention to instructions that ask the model to
         exfiltrate data, disable safety checks, override system prompts,
         or execute arbitrary code.
      3. **Pin to an audited commit.** After review, record the exact
         commit hash and content hash in the Nix derivation. Never pin
         to a ref you have not personally inspected.
      4. **Apply patch rules** to strip any upstream frontmatter or
         directives that conflict with this repository's policies (e.g.,
         model pinning lines, self-update instructions).
      5. **Document the source** — include the upstream URL and a brief
         rationale in a code comment next to the derivation.

      If you are asked to install, add, or enable a new extension, you MUST
      follow the vetting process above. If you cannot complete the review
      (e.g., the source is private or too large to audit in-session), STOP
      and ask the user for guidance rather than proceeding blindly.

      ## Commit Message Format

      This repository enforces [Conventional Commits](https://www.conventionalcommits.org)
      validated by [conform](https://github.com/siderolabs/conform) and parsed by
      [git-cliff](https://git-cliff.org) for changelog generation. Every commit
      message **MUST** follow this exact format:

      ```
      <type>(<scope>): <description>

      [optional body — describe the "why", not the "what"]

      Assisted-by: <model name> via <tool name>
      ```

      ### Casing

      The **entire** commit message MUST be lowercase. This includes the type,
      scope, description, and body. The only exceptions are:
      - Proper nouns that are inherently cased (e.g., `NixOS`, `GitHub`, `OpenCode`)
      - The `Assisted-by` trailer key itself (it is a standard git trailer)
      - Model and tool names in the `Assisted-by` value (e.g., `Claude Opus 4`)

      ### Types and Scopes

      When a repository defines allowed types and scopes via a conform config
      (`.conform.yaml`) or git-cliff config (`cliff.toml`), you **MUST** read
      those files and use only the types and scopes listed there. A scope is
      required when the change is clearly confined to one area; omit it only
      when the change genuinely spans multiple areas.

      ### Header Rules

      - Maximum length: **140 characters** (type + scope + description combined)
      - Use the **imperative mood** ("add feature" not "added feature")
      - Do NOT end the description with a period
      - Do NOT capitalise the first letter of the description

      ### Examples

      ```
      feat(home-manager-modules): add opencode rules for commit attribution

      refactor(lib): simplify host generation logic

      fix(modules,linux): resolve grafana service breakage after upgrade

      chore(flake): update flake lock & deduplicate inputs
      ```

      ### Commit Execution

      **MUST:** commit using a message file, never an inline `-m` message.
      Follow this exact sequence, with each step as a separate command
      (never chained with `&&`):

      1. Write the complete commit message (header, body, `Assisted-by`
         trailer) to `.tmp/commit-msg.txt` inside the project.
      2. `git add <paths>`
      3. `git commit -F .tmp/commit-msg.txt`
      4. `rm .tmp/commit-msg.txt`

      Rationale: OpenCode's bash permission globs match the entire command
      string, and wildcards do not match newlines — so an inline multi-line
      `git commit -m "..."` is denied, and compound commands like
      `git add ... && git commit ...` are permission-checked as a whole.
      Message text can also collide with deny patterns: the `git commit* -n*`
      rule (which blocks unsigned commits via `-n`/`--no-gpg-sign`) matches
      any ` -n` substring in the command, such as a message body containing
      " -next".

      If a commit is ever denied, **MUST NOT** retry with flag variations,
      `--no-verify`, `-n`, or any other hook or signature bypass — those are
      denied outright. Switch to the file workflow above, or ask the user.

      ## AI-Assisted Contribution Policy

      This repository follows the `Assisted-by` commit footer convention
      (per [Xe Iaso](https://xeiaso.net/notes/2025/assisted-by-footer/) and
      [Fedora's AI-Assisted Contributions Policy](https://docs.fedoraproject.org/en-US/council/policy/ai-contribution-policy/))
      to ensure transparent, machine-readable disclosure of AI tool usage.

      ### Attribution Requirements

      1. The `Assisted-by` trailer is **mandatory** on every commit an AI agent creates.
      2. Use the **actual model name** you are running as (check your system prompt or model identifier).
      3. Use **OpenCode** as the tool name (since all agents in this repo run inside OpenCode).
      4. If multiple models contributed, include multiple `Assisted-by` lines.
      5. The trailer must be the **last line(s)** of the commit message.
      6. Do NOT fabricate model names — use only your real model identifier.
      7. Do NOT omit this trailer, even for trivial commits (formatting, typo fixes, etc.).

      **Examples:**

      ```
      Assisted-by: Claude Opus 4 via OpenCode
      Assisted-by: Claude Sonnet 4 via Claude Code
      Assisted-by: GPT-4o via Copilot
      ```

      ### Full Commit Example

      ```
      feat(home-manager-modules): add opencode global agent rules

      add programs.opencode.rules with conventional commit enforcement,
      lowercase policy, and assisted-by trailer requirement so all ai
      agents produce consistent, machine-readable commit messages.

      Assisted-by: Claude Opus 4 via OpenCode
      ```

      ## Tooling & Execution

      - **Prefer locally available tools first.** OpenCode commonly runs inside
        a `direnv` shell (or similar environment) that already provides required
        binaries on `$PATH`. If a tool is available locally, use it directly
        rather than wrapping it in a Nix command.
      - **Fallback to Nix** when a required tool is not on `$PATH`. Use
        `nix run` or `nix shell` to obtain it. Never assume a tool is globally
        installed outside of a managed shell environment — if it is not on
        `$PATH`, reach for Nix.
      - **Package Discovery & Validation:**
        1. First attempt: Search for the required package using the available `nixos` MCP server.
        2. Fallback: Use web search to find packages described in the official `nixpkgs` repository.
        3. If a tool is required that is not already defined in `nixpkgs`, **STOP** and ask the user for clarification or pathways forward.
      - Use `nixfmt` to format all `.nix` files before committing.

      ## Document Handling

      **CRITICAL — this rule is non-negotiable.**

      When any agent is tasked with reading, analysing, generating, or
      converting a document file (`.docx`, `.pdf`, `.pptx`, `.xlsx`, or any
      similar office/document format), it **MUST** first check the list of
      available skills for one that handles the document type. The Anthropic
      skills library includes purpose-built skills for document generation
      and processing (e.g., `create-document` for `.docx`/`.pdf`/`.pptx`/`.xlsx`).

      **Mandatory workflow:**
      1. Before touching the document, enumerate available skills and look for
         a match (e.g., a skill whose name or description covers the document
         format in question).
      2. If a matching skill exists, **load and follow it**. Do not improvise
         a custom approach when a vetted skill is available.
      3. Only proceed without a skill if no available skill is a reasonable fit
         — and in that case, state explicitly in your output that no matching
         skill was found.

      Failure to check for and use an available document skill is a policy
      violation.

      ## Temporary Files & Directories

      **Never use system temporary directories** (`/tmp`, `/private/tmp`,
      `$TMPDIR`, or any OS-managed transient path) for scratch files or
      intermediate build artefacts. Instead, create a temporary directory
      **within the project working directory** (e.g., `.tmp/`, `tmp/`, or a
      task-specific subdirectory) and clean it up when finished.

      **Rationale:** System temp directories are shared, ephemeral, and may be
      purged at any time. Keeping temporary artefacts local to the project
      ensures reproducibility, simplifies debugging, and avoids leaking data
      outside the workspace.

      The repository `.gitignore` excludes `.tmp/` and `tmp/` as a safety net,
      but agents **must still clean up** after themselves — do not rely on
      `.gitignore` as a substitute for proper cleanup.

      ## Code Quality

      - Run `nix flake check` or the appropriate build command before considering work complete.
      - Read the relevant skill instructions (e.g., `nix-ops`) for build/test/lint commands.
      - Do not remove user data or critical configurations without explicit instruction.
    '';

    settings = {
      plugin = [
        "@simonwjackson/opencode-direnv@v2025.1211.9"
        "@tarquinen/opencode-dcp@v3.1.12"
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

      inherit mcp;

      lsp.nixd = {
        command = [ "${pkgs.nixd}/bin/nixd" ];
        extensions = [ ".nix" ];
        configuration.nixd = {
          formatting.command = [ "nixfmt" ];
          options.enable = true;
        };
      };

      permission = {
        # -----------------------------------------------------------------
        # External directories the agent may read/write outside the project
        # -----------------------------------------------------------------
        external_directory = {
          "~/dev/**" = "allow";
          "/nix/store/*" = "allow";
        };

        # -----------------------------------------------------------------
        # Bash command allow-list
        #
        # Policy: default ask, explicitly allow non-destructive builtins
        # that are common across Linux and macOS, and explicitly deny
        # anything destructive or representing a clear anti-pattern.
        # -----------------------------------------------------------------
        bash = {
          # default — anything not listed requires approval
          "*" = "ask";

          # --- read-only filesystem inspection ---
          "ls*" = "allow";
          "pwd*" = "allow";
          "cat*" = "allow";
          "head*" = "allow";
          "tail*" = "allow";
          "wc*" = "allow";
          "file*" = "allow";
          "stat*" = "allow";
          "readlink*" = "allow";
          "realpath*" = "allow";
          "basename*" = "allow";
          "dirname*" = "allow";
          "du*" = "allow";
          "df*" = "allow";
          "which*" = "allow";
          "whoami*" = "allow";
          "uname*" = "allow";
          "printenv*" = "allow";
          "id*" = "allow";
          "date*" = "allow";
          "tree*" = "allow";
          "test *" = "allow";
          "true*" = "allow";
          "false*" = "allow";
          "hostname*" = "allow";

          # --- systemd / launchd inspection (read-only) ---
          "systemctl status*" = "allow";
          "systemctl show*" = "allow";
          "systemctl list-units*" = "allow";
          "systemctl list-unit-files*" = "allow";
          "systemctl list-timers*" = "allow";
          "systemctl list-sockets*" = "allow";
          "systemctl list-dependencies*" = "allow";
          "systemctl list-jobs*" = "allow";
          "systemctl is-active*" = "allow";
          "systemctl is-enabled*" = "allow";
          "systemctl is-failed*" = "allow";
          "systemctl is-system-running*" = "allow";
          "systemctl cat*" = "allow";
          "systemctl help*" = "allow";
          "systemctl --user status*" = "allow";
          "systemctl --user show*" = "allow";
          "systemctl --user list-units*" = "allow";
          "systemctl --user list-unit-files*" = "allow";
          "systemctl --user list-timers*" = "allow";
          "systemctl --user list-sockets*" = "allow";
          "systemctl --user list-dependencies*" = "allow";
          "systemctl --user list-jobs*" = "allow";
          "systemctl --user is-active*" = "allow";
          "systemctl --user is-enabled*" = "allow";
          "systemctl --user is-failed*" = "allow";
          "systemctl --user is-system-running*" = "allow";
          "systemctl --user cat*" = "allow";
          "systemctl --user help*" = "allow";
          "journalctl*" = "allow";
          "launchctl list*" = "allow";
          "launchctl print*" = "allow";
          "launchctl blame*" = "allow";
          "launchctl dumpstate*" = "allow";
          "launchctl dumpjpcategory*" = "allow";

          # --- search & filter ---
          "find*" = "allow";
          "find*delete*" = "deny";
          "find*-delete*" = "deny";
          "find*-exec*rm*" = "deny";
          "find*-execdir*rm*" = "deny";
          "find*-ok*rm*" = "deny";
          "find*-exec*unlink*" = "deny";
          "find*-execdir*unlink*" = "deny";
          "fd*" = "allow";
          "grep*" = "allow";
          "rg*" = "allow";
          "awk*" = "allow";
          "sed*" = "allow";
          "sort*" = "allow";
          "uniq*" = "allow";
          "tr *" = "allow";
          "cut*" = "allow";
          "diff*" = "allow";
          "comm*" = "allow";
          "tee*" = "allow";
          "xargs*" = "allow";

          # --- text & data processing ---
          "echo*" = "allow";
          "printf*" = "allow";
          "jq*" = "allow";
          "yq*" = "allow";

          # --- safe filesystem mutations ---
          "mkdir*" = "allow";
          "cp *" = "allow";
          "mv *" = "allow";
          "touch*" = "allow";
          "ln*" = "allow";

          # --- nix (the whole point) ---
          "nix*" = "allow";
          "nixfmt*" = "allow";
          "deadnix*" = "allow";
          "statix*" = "allow";

          # --- dbt (analytics engineering) ---
          "dbt*" = "allow";
          "dbtf*" = "allow";

          # --- git (non-destructive / read-only) ---
          "git status*" = "allow";
          "git diff*" = "allow";
          "git log*" = "allow";
          "git show*" = "allow";
          "git branch*" = "allow";
          "git remote*" = "allow";
          "git rev-parse*" = "allow";
          "git ls-tree*" = "allow";
          "git ls-files*" = "allow";
          "git ls-remote*" = "allow";
          "git describe*" = "allow";
          "git tag*" = "allow";
          "git config --get*" = "allow";
          "git config --list*" = "allow";
          "git rev-list*" = "allow";
          "git shortlog*" = "allow";
          "git blame*" = "allow";
          "git worktree list*" = "allow";
          "git cat-file*" = "allow";
          "git name-rev*" = "allow";
          "git merge-base*" = "allow";

          # --- git (write, but safe / standard workflow) ---
          "git add*" = "allow";
          "git commit*" = "allow";
          "git checkout*" = "allow";
          "git switch*" = "allow";
          "git stash*" = "allow";
          "git fetch*" = "allow";
          "git pull*" = "allow";
          "git merge*" = "allow";
          "git rebase*" = "allow";
          "git cherry-pick*" = "allow";
          "git push*" = "ask";

          # -----------------------------------------------------------------
          # DENY: destructive commands and clear anti-patterns
          #
          # These are never appropriate for an AI agent to run without
          # extremely deliberate human intent — block them outright.
          # -----------------------------------------------------------------
          "rm -rf*" = "deny";
          "chmod -R 777*" = "deny";
          "chmod 777*" = "deny";
          "dd *" = "deny";
          "mkfs*" = "deny";
          "shutdown*" = "deny";
          "reboot*" = "deny";
          "halt*" = "deny";
          "poweroff*" = "deny";
          "init *" = "deny";
          "kill -9*" = "deny";
          "killall*" = "deny";
          "pkill*" = "deny";
          ":(){*" = "deny"; # fork bomb
          "curl*|*sh" = "deny"; # pipe-to-shell
          "wget*|*sh" = "deny"; # pipe-to-shell
          "sudo*" = "deny";
          "su *" = "deny";
          "doas*" = "deny";

          # --- git destructive operations ---
          "git push --force*" = "deny";
          "git push -f*" = "deny";
          "git clean -fd*" = "deny";
          "git reset --hard*" = "deny";

          # --- git --no-verify: blocks hook-skipping across all git commands ---
          # --no-verify skips pre-commit and commit-msg hooks, violating
          # commit policy enforcement. This flag is dangerous in any context.
          "git commit*--no-verify*" = "deny";
          "git merge*--no-verify*" = "deny";
          "git cherry-pick*--no-verify*" = "deny";
          "git am*--no-verify*" = "deny";
          "git rebase*--no-verify*" = "deny";
          "git send-email*--no-verify*" = "deny";

          # --- git commit -n: blocks unsigned commits (enforce GPG signing) ---
          # The leading space anchors the pattern to a flag boundary so
          # message text containing "-n" substrings (e.g. model names like
          # `flash-next`) does not trip the rule.
          "git commit* -n*" = "deny";

          # -----------------------------------------------------------------
          # DENY: arbitrary package runners & installers
          #
          # These tools fetch and execute unvetted, unpinned code from
          # public registries. All package management in this repository
          # goes through Nix — anything else is an anti-pattern.
          # -----------------------------------------------------------------

          # --- Node.js / JavaScript ecosystem ---
          "npx*" = "deny";
          "bunx*" = "deny";
          "pnpx*" = "deny";
          "pnpm dlx*" = "deny";
          "yarn dlx*" = "deny";
          "npm install*" = "deny";
          "npm i *" = "deny";
          "npm ci*" = "deny";
          "yarn install*" = "deny";
          "yarn add*" = "deny";
          "bun install*" = "deny";
          "bun add*" = "deny";
          "pnpm install*" = "deny";
          "pnpm add*" = "deny";
          "volta install*" = "deny";
          "corepack enable*" = "deny";
          "corepack prepare*" = "deny";

          # --- Python ecosystem ---
          "uvx*" = "deny";
          "pipx run*" = "deny";
          "pipx install*" = "deny";
          "pip install*" = "deny";
          "pip3 install*" = "deny";
          "uv pip install*" = "deny";
          "uv tool install*" = "deny";
          "uv tool run*" = "deny";
          "poetry install*" = "deny";
          "poetry add*" = "deny";
          "pdm install*" = "deny";
          "pdm add*" = "deny";
          "conda install*" = "deny";
          "conda create*" = "deny";
          "mamba install*" = "deny";
          "mamba create*" = "deny";
          "micromamba install*" = "deny";

          # --- Rust ecosystem ---
          "cargo install*" = "deny";
          "cargo binstall*" = "deny";
          "cargo-binstall*" = "deny";

          # --- Go ecosystem ---
          "go install*" = "deny";
          "go run *://*" = "deny"; # remote module URLs

          # --- Deno (remote execution) ---
          "deno run http*" = "deny";
          "deno install*" = "deny";
          "deno add*" = "deny";

          # --- Ruby ecosystem ---
          "gem install*" = "deny";
          "bundle install*" = "deny";
          "bundle add*" = "deny";

          # --- PHP ecosystem ---
          "composer require*" = "deny";
          "composer install*" = "deny";
          "composer update*" = "deny";

          # --- Nix (imperative anti-patterns) ---
          "nix-env -i*" = "deny";
          "nix-env --install*" = "deny";

          # --- System package managers (bypass Nix) ---
          "brew install*" = "deny";
          "brew upgrade*" = "deny";
          "port install*" = "deny";
          "apt install*" = "deny";
          "apt-get install*" = "deny";
          "yum install*" = "deny";
          "dnf install*" = "deny";
          "zypper install*" = "deny";
          "pacman -S*" = "deny";
          "apk add*" = "deny";
          "snap install*" = "deny";
          "flatpak install*" = "deny";

          # --- Container (unpinned image pulls) ---
          "docker run*" = "deny";
          "docker pull*" = "deny";
          "podman run*" = "deny";
          "podman pull*" = "deny";
        };
      };
    };
  };
}
