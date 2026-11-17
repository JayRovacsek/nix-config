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
    superpowers
    wshobson-agents
    ;

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
    // lib.optionalAttrs (lib.meta.availableOn pkgs.stdenv.hostPlatform rea) {
      reverse-engineer-anything = "${rea}/lib/node_modules/rea-agents/skills/reverse-engineer-anything";
      rea-analysis-optimization = "${rea}/lib/node_modules/rea-agents/.agents/skills/rea-analysis-optimization";
      rea-changelog-update = "${rea}/lib/node_modules/rea-agents/.agents/skills/rea-changelog-update";
      rea-ci-tests-audit = "${rea}/lib/node_modules/rea-agents/.agents/skills/rea-ci-tests-audit";
      rea-tool-design = "${rea}/lib/node_modules/rea-agents/.agents/skills/rea-tool-design";
    }
    // wshobsonSkills
    # Local
    // {
      extension-vetting = ./skills/extension-vetting;
      git-commit = ./skills/git-commit;
      nix-build-verification = ./skills/nix-build-verification;
      nix-ops = ./skills/nix-ops;
      nix-tooling-workflow = ./skills/nix-tooling-workflow;
      nixos-test-dev = ./skills/nixos-test-dev;
      product-management = ./skills/product-management;
      working-with-nix = ./skills/working-with-nix;
    };
in
{
  # Imported by several agent modules; a stable key stops the module system
  # loading it once per importer and concatenating the duplicated skill paths.
  key = "home-manager-modules/skills";

  imports = [ ../../options/home-manager-modules/skills ];

  programs.skills = {
    enable = true;

    # Skills are assembled above from local Nix paths plus the curated
    # artefacts listed in this file, and distributed to each agent through its
    # `enableSkillIntegration` option. Skills accept store-path strings because
    # Home Manager special-cases them (via `isPathLike`).
    inherit skills;
  };
}
