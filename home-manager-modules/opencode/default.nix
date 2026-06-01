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

  agents =
    # Superpowers
    {
      code-reviewer = "${superpowers}/share/agents/code-reviewer.md";
    }
    # wshobson agents
    // {
      ai-engineer = "${wshobson-agents}/share/agents/ai-engineer.md";
      bash-pro = "${wshobson-agents}/share/agents/bash-pro.md";
      business-analyst = "${wshobson-agents}/share/agents/business-analyst.md";
      cloud-architect = "${wshobson-agents}/share/agents/cloud-architect.md";
      code-reviewer = "${wshobson-agents}/share/agents/code-reviewer.md";
      context-manager = "${wshobson-agents}/share/agents/context-manager.md";
      data-engineer = "${wshobson-agents}/share/agents/data-engineer.md";
      data-scientist = "${wshobson-agents}/share/agents/data-scientist.md";
      database-architect = "${wshobson-agents}/share/agents/database-architect.md";
      database-optimizer = "${wshobson-agents}/share/agents/database-optimizer.md";
      docs-architect = "${wshobson-agents}/share/agents/docs-architect.md";
      error-detective = "${wshobson-agents}/share/agents/error-detective.md";
      eval-judge = "${wshobson-agents}/share/agents/eval-judge.md";
      eval-orchestrator = "${wshobson-agents}/share/agents/eval-orchestrator.md";
      frontend-developer = "${wshobson-agents}/share/agents/frontend-developer.md";
      hr-pro = "${wshobson-agents}/share/agents/hr-pro.md";
      image-generator = "${wshobson-agents}/share/agents/image-generator.md";
      legal-advisor = "${wshobson-agents}/share/agents/legal-advisor.md";
      mermaid-expert = "${wshobson-agents}/share/agents/mermaid-expert.md";
      ml-engineer = "${wshobson-agents}/share/agents/ml-engineer.md";
      mlops-engineer = "${wshobson-agents}/share/agents/mlops-engineer.md";
      orchestrate = "${wshobson-agents}/share/agents/orchestrate.md";
      performance-engineer = "${wshobson-agents}/share/agents/performance-engineer.md";
      playwright = "${wshobson-agents}/share/agents/playwright.md";
      policy-enforcer = "${wshobson-agents}/share/agents/policy-enforcer.md";
      posix-shell-pro = "${wshobson-agents}/share/agents/posix-shell-pro.md";
      prompt-crafter = "${wshobson-agents}/share/agents/prompt-crafter.md";
      prompt-engineer = "${wshobson-agents}/share/agents/prompt-engineer.md";
      python-pro = "${wshobson-agents}/share/agents/python-pro.md";
      qa = "${wshobson-agents}/share/agents/qa.md";
      review-policy-author = "${wshobson-agents}/share/agents/review-policy-author.md";
      review = "${wshobson-agents}/share/agents/review.md";
      security-auditor = "${wshobson-agents}/share/agents/security-auditor.md";
      sql-pro = "${wshobson-agents}/share/agents/sql-pro.md";
      startup-analyst = "${wshobson-agents}/share/agents/startup-analyst.md";
      threat-modeling-expert = "${wshobson-agents}/share/agents/threat-modeling-expert.md";
      typescript-pro = "${wshobson-agents}/share/agents/typescript-pro.md";
    }
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
    // {
      api-design-principles = "${wshobson-agents}/share/skills/api-design-principles";
      architecture-decision-records = "${wshobson-agents}/share/skills/architecture-decision-records";
      architecture-patterns = "${wshobson-agents}/share/skills/architecture-patterns";
      async-python-patterns = "${wshobson-agents}/share/skills/async-python-patterns";
      bash-defensive-patterns = "${wshobson-agents}/share/skills/bash-defensive-patterns";
      bats-testing-patterns = "${wshobson-agents}/share/skills/bats-testing-patterns";
      billing-automation = "${wshobson-agents}/share/skills/billing-automation";
      binary-analysis-patterns = "${wshobson-agents}/share/skills/binary-analysis-patterns";
      block-no-verify-hook = "${wshobson-agents}/share/skills/block-no-verify-hook";
      changelog-automation = "${wshobson-agents}/share/skills/changelog-automation";
      code-review-excellence = "${wshobson-agents}/share/skills/code-review-excellence";
      context-driven-development = "${wshobson-agents}/share/skills/context-driven-development";
      cost-optimization = "${wshobson-agents}/share/skills/cost-optimization";
      data-quality-frameworks = "${wshobson-agents}/share/skills/data-quality-frameworks";
      data-storytelling = "${wshobson-agents}/share/skills/data-storytelling";
      database-migration = "${wshobson-agents}/share/skills/database-migration";
      dbt-transformation-patterns = "${wshobson-agents}/share/skills/dbt-transformation-patterns";
      debugging-strategies = "${wshobson-agents}/share/skills/debugging-strategies";
      dependency-upgrade = "${wshobson-agents}/share/skills/dependency-upgrade";
      deployment-pipeline-design = "${wshobson-agents}/share/skills/deployment-pipeline-design";
      design-system-patterns = "${wshobson-agents}/share/skills/design-system-patterns";
      error-handling-patterns = "${wshobson-agents}/share/skills/error-handling-patterns";
      evaluation-methodology = "${wshobson-agents}/share/skills/evaluation-methodology";
      event-store-design = "${wshobson-agents}/share/skills/event-store-design";
      gdpr-data-handling = "${wshobson-agents}/share/skills/gdpr-data-handling";
      git-advanced-workflows = "${wshobson-agents}/share/skills/git-advanced-workflows";
      github-actions-templates = "${wshobson-agents}/share/skills/github-actions-templates";
      gitops-workflow = "${wshobson-agents}/share/skills/gitops-workflow";
      godot-gdscript-patterns = "${wshobson-agents}/share/skills/godot-gdscript-patterns";
      grafana-dashboards = "${wshobson-agents}/share/skills/grafana-dashboards";
      interaction-design = "${wshobson-agents}/share/skills/interaction-design";
      javascript-testing-patterns = "${wshobson-agents}/share/skills/javascript-testing-patterns";
      kpi-dashboard-design = "${wshobson-agents}/share/skills/kpi-dashboard-design";
      linkerd-patterns = "${wshobson-agents}/share/skills/linkerd-patterns";
      llm-evaluation = "${wshobson-agents}/share/skills/llm-evaluation";
      market-sizing-analysis = "${wshobson-agents}/share/skills/market-sizing-analysis";
      ml-pipeline-workflow = "${wshobson-agents}/share/skills/ml-pipeline-workflow";
      modern-javascript-patterns = "${wshobson-agents}/share/skills/modern-javascript-patterns";
      multi-cloud-architecture = "${wshobson-agents}/share/skills/multi-cloud-architecture";
      multi-reviewer-patterns = "${wshobson-agents}/share/skills/multi-reviewer-patterns";
      nodejs-backend-patterns = "${wshobson-agents}/share/skills/nodejs-backend-patterns";
      parallel-debugging = "${wshobson-agents}/share/skills/parallel-debugging";
      parallel-feature-development = "${wshobson-agents}/share/skills/parallel-feature-development";
      pci-compliance = "${wshobson-agents}/share/skills/pci-compliance";
      prompt-engineering-patterns = "${wshobson-agents}/share/skills/prompt-engineering-patterns";
      protect-mcp-setup = "${wshobson-agents}/share/skills/protect-mcp-setup";
      python-anti-patterns = "${wshobson-agents}/share/skills/python-anti-patterns";
      python-background-jobs = "${wshobson-agents}/share/skills/python-background-jobs";
      python-code-style = "${wshobson-agents}/share/skills/python-code-style";
      python-configuration = "${wshobson-agents}/share/skills/python-configuration";
      python-design-patterns = "${wshobson-agents}/share/skills/python-design-patterns";
      python-error-handling = "${wshobson-agents}/share/skills/python-error-handling";
      python-observability = "${wshobson-agents}/share/skills/python-observability";
      python-packaging = "${wshobson-agents}/share/skills/python-packaging";
      python-performance-optimization = "${wshobson-agents}/share/skills/python-performance-optimization";
      python-project-structure = "${wshobson-agents}/share/skills/python-project-structure";
      python-resilience = "${wshobson-agents}/share/skills/python-resilience";
      python-resource-management = "${wshobson-agents}/share/skills/python-resource-management";
      python-testing-patterns = "${wshobson-agents}/share/skills/python-testing-patterns";
      python-type-safety = "${wshobson-agents}/share/skills/python-type-safety";
      rag-implementation = "${wshobson-agents}/share/skills/rag-implementation";
      review-agent-setup = "${wshobson-agents}/share/skills/review-agent-setup";
      risk-metrics-calculation = "${wshobson-agents}/share/skills/risk-metrics-calculation";
      secrets-management = "${wshobson-agents}/share/skills/secrets-management";
      security-requirement-extraction = "${wshobson-agents}/share/skills/security-requirement-extraction";
      service-mesh-observability = "${wshobson-agents}/share/skills/service-mesh-observability";
      shellcheck-configuration = "${wshobson-agents}/share/skills/shellcheck-configuration";
      signed-audit-trails-recipe = "${wshobson-agents}/share/skills/signed-audit-trails-recipe";
      similarity-search-patterns = "${wshobson-agents}/share/skills/similarity-search-patterns";
      slo-implementation = "${wshobson-agents}/share/skills/slo-implementation";
      sql-optimization-patterns = "${wshobson-agents}/share/skills/sql-optimization-patterns";
      stride-analysis-patterns = "${wshobson-agents}/share/skills/stride-analysis-patterns";
      task-coordination-strategies = "${wshobson-agents}/share/skills/task-coordination-strategies";
      threat-mitigation-mapping = "${wshobson-agents}/share/skills/threat-mitigation-mapping";
      typescript-advanced-types = "${wshobson-agents}/share/skills/typescript-advanced-types";
      uv-package-manager = "${wshobson-agents}/share/skills/uv-package-manager";
      vector-index-tuning = "${wshobson-agents}/share/skills/vector-index-tuning";
      workflow-orchestration-patterns = "${wshobson-agents}/share/skills/workflow-orchestration-patterns";
      workflow-patterns = "${wshobson-agents}/share/skills/workflow-patterns ";
    }
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
      brainstorm = "${superpowers}/share/commands/brainstorm";
      execute-plan = "${superpowers}/share/commands/execute-plan";
      write-plan = "${superpowers}/share/commands/write-plan";
    }
    # Wshobson
    // {
      ai-assistant = "${wshobson-agents}/share/commands/ai-assistant.md";
      ai-review = "${wshobson-agents}/share/commands/ai-review.md";
      approve-review = "${wshobson-agents}/share/commands/approve-review.md";
      audit-chain = "${wshobson-agents}/share/commands/audit-chain.md";
      block-no-verify = "${wshobson-agents}/share/commands/block-no-verify.md";
      business-case = "${wshobson-agents}/share/commands/business-case.md";
      code-explain = "${wshobson-agents}/share/commands/code-explain.md";
      code-migrate = "${wshobson-agents}/share/commands/code-migrate.md";
      compare = "${wshobson-agents}/share/commands/compare.md";
      compliance-check = "${wshobson-agents}/share/commands/compliance-check.md";
      component-scaffold = "${wshobson-agents}/share/commands/component-scaffold.md";
      config-validate = "${wshobson-agents}/share/commands/config-validate.md";
      context-restore = "${wshobson-agents}/share/commands/context-restore.md";
      context-save = "${wshobson-agents}/share/commands/context-save.md";
      cost-optimize = "${wshobson-agents}/share/commands/cost-optimize.md";
      data-driven-feature = "${wshobson-agents}/share/commands/data-driven-feature.md";
      data-pipeline = "${wshobson-agents}/share/commands/data-pipeline.md";
      deps-audit = "${wshobson-agents}/share/commands/deps-audit.md";
      deps-upgrade = "${wshobson-agents}/share/commands/deps-upgrade.md";
      design-review = "${wshobson-agents}/share/commands/design-review.md";
      doc-generate = "${wshobson-agents}/share/commands/doc-generate.md";
      error-analysis = "${wshobson-agents}/share/commands/error-analysis.md";
      find = "${wshobson-agents}/share/commands/find.md";
      full-review = "${wshobson-agents}/share/commands/full-review.md";
      full-stack-feature = "${wshobson-agents}/share/commands/full-stack-feature.md";
      git-workflow = "${wshobson-agents}/share/commands/git-workflow.md";
      improve-agent = "${wshobson-agents}/share/commands/improve-agent.md";
      list-pending = "${wshobson-agents}/share/commands/list-pending.md";
      manage = "${wshobson-agents}/share/commands/manage.md";
      ml-pipeline = "${wshobson-agents}/share/commands/ml-pipeline.md";
      multi-agent-optimize = "${wshobson-agents}/share/commands/multi-agent-optimize.md";
      multi-agent-review = "${wshobson-agents}/share/commands/multi-agent-review.md";
      multi-platform = "${wshobson-agents}/share/commands/multi-platform.md";
      performance-optimization = "${wshobson-agents}/share/commands/performance-optimization.md";
      pr-enhance = "${wshobson-agents}/share/commands/pr-enhance.md";
      prompt-optimize = "${wshobson-agents}/share/commands/prompt-optimize.md";
      python-scaffold = "${wshobson-agents}/share/commands/python-scaffold.md";
      refactor-clean = "${wshobson-agents}/share/commands/refactor-clean.md";
      slo-implement = "${wshobson-agents}/share/commands/slo-implement.md";
      sql-migrations = "${wshobson-agents}/share/commands/sql-migrations.md";
      typescript-scaffold = "${wshobson-agents}/share/commands/typescript-scaffold.md";
      verify-receipt = "${wshobson-agents}/share/commands/verify-receipt.md";
      workflow-automate = "${wshobson-agents}/share/commands/workflow-automate.md";
    };

  snowflake-mcp-config = builtins.toFile "snowflake-mcp-config.yaml" (
    lib.generators.toYAML { } {
      other_services = {
        object_manager = false;
        query_manager = true;
        semantic_manager = true;

        sql_statement_permissions = [
          { Alter = false; }
          { Command = false; }
          { Comment = false; }
          { Commit = false; }
          { Copy = false; }
          { Create = false; }
          { Delete = false; }
          { Describe = true; }
          { Drop = false; }
          { Insert = false; }
          { Merge = false; }
          { Rollback = false; }
          { Select = true; }
          { Transaction = false; }
          { TruncateTable = false; }
          { Unknown = false; }
          { Update = false; }
          { Use = true; }
        ];
      };
    }
  );

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

    # GitHub API: issues, PRs, repos, code search, CI status
    # Requires GITHUB_PERSONAL_ACCESS_TOKEN in the environment at runtime
    (mkMcpServer {
      name = "snowflake";
      command = [ "snowflake-labs-mcp" ];
      args = [
        "--service-config-file"
        snowflake-mcp-config
        "--authenticator"
        "externalbrowser"
      ];
    })

    (mkMcpServer {
      name = "atlassian";
      url = "https://mcp.atlassian.com/v1/mcp";
    })
  ];
in
{

  programs.opencode.settings.provider =
    # lib.mkIf osConfig.services.llama-cpp.enable
    {
      # TODO: Correct this to leverage common config options, expose only over tailscale or alike
      llama-cpp = {
        npm = "@ai-sdk/openai-compatible";
        name = "llama-cpp";
        options = {
          baseURL = "http://192.168.1.220:8080/v1";
        };
        models = {
          gemma-4-E2B = {
            name = "unsloth/gemma-4-E4B-it-GGUF";
            limit = {
              context = 128000;
              output = 65536;
            };
          };
        };

        #   builtins.mapAttrs (key: value: {
        #   name = if value ? alias && value.alias != "" then value.alias else key;
        #   contextLength = value.n_ctx or null;
        # }

        # ) osConfig.services.llama-cpp.modelsPreset;
      };
    };

  programs.opencode = {
    enable = true;

    package = pkgs.opencode;

    # Local agents/commands are Nix path types and pass through the HM
    # option's lib.isPath check correctly (creating symlinks).
    # External agents/commands are handled via xdg.configFile below.
    inherit agents skills commands;

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
         this step, even for small or seemingly trivial edits.
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
      ];

      # Only offer models from locally defined providers — GitHub Copilot
      # (built-in, authenticated via device flow) and Ollama (custom,
      # defined in home-manager-modules/ollama).
      # TODO: Make this a bit smarter on how it's built - hardcoded while testing
      enabled_providers = lib.unique [
        "github-copilot"
        "ollama"
        "llama-cpp"
      ];

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
          "git commit*-n*" = "deny";

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
