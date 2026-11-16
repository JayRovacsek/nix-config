_: {
  # Imported by several agent modules; a stable key stops the module system
  # loading it once per importer.
  key = "home-manager-modules/agent-context";

  imports = [ ../../options/home-manager-modules/agent-context ];

  programs.agent-context = {
    enable = true;

    # Global agent instructions, written to each assistant's global context file
    # (e.g. $XDG_CONFIG_HOME/opencode/AGENTS.md or ~/.claude/CLAUDE.md).
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
      servers — are **declaratively managed via Nix configuration**. When
      asked to install, add, or enable a new extension, load and follow the
      `extension-vetting` skill for the complete vetting workflow.

      ## Commit Message Format

      All commits enforce [Conventional Commits](https://www.conventionalcommits.org)
      validated by [conform](https://github.com/siderolabs/conform) and parsed by
      [git-cliff](https://git-cliff.org) for changelog generation. Every commit
      message **MUST** follow the format, execution workflow and AI attribution
      rules defined by the `git-commit` skill. Load and follow it immediately.

      ## Tooling & Execution

      - Load the `nix-tooling-workflow` skill for tool discovery, package validation, and formatting patterns.

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

      - Load the `nix-build-verification` skill for build verification, linting, and testing patterns for Nix code.
    '';
  };
}
