{
  lib,
  pkgs,
  ...
}:
let
  # ---------------------------------------------------------------------------
  # mkOpencodeSource: Generic builder for external agent/skill/command sources
  #
  # Takes a source (fetchFromGitHub or flake input), applies patch rules to
  # strip unwanted frontmatter from .md files, then copies selected component
  # subdirectories into a normalised $out/{agents,skills,commands}/ structure.
  # ---------------------------------------------------------------------------
  mkOpencodeSource =
    {
      name,
      src,
      patchRules ? [ ],
      components ? { },
    }:
    let
      agentPaths = components.agents or [ ];
      skillPaths = components.skills or [ ];
      commandPaths = components.commands or [ ];

      # Generate sed delete-line commands for each patch rule regex
      sedArgs = lib.concatMapStringsSep " " (
        pattern: "-e '/${pattern}/d'"
      ) patchRules;

      patchPhase = lib.optionalString (
        patchRules != [ ]
      ) "find . -name '*.md' -type f -exec ${pkgs.gnused}/bin/sed -i ${sedArgs} {} +";

      # Copy a list of source subdirectories into a target directory,
      # preserving internal structure. Note: cp -rT is last-wins on
      # filename conflicts (unlike symlinkJoin which is first-wins).
      # This is safe here because paths come from a single upstream repo.
      copyComponents =
        targetDir: paths:
        lib.concatMapStringsSep "\n" (srcPath: ''
          if [ -d "${srcPath}" ]; then
            cp -rT "${srcPath}" "$out/${targetDir}"
          fi
        '') paths;
    in
    pkgs.stdenv.mkDerivation {
      inherit name src;

      dontBuild = true;
      dontFixup = true;

      nativeBuildInputs = lib.optional (patchRules != [ ]) pkgs.gnused;

      postPatch = patchPhase;

      installPhase = ''
        mkdir -p $out/{agents,skills,commands}
        ${copyComponents "agents" agentPaths}
        ${copyComponents "skills" skillPaths}
        ${copyComponents "commands" commandPaths}
      '';
    };

  # ---------------------------------------------------------------------------
  # mkMcpServer: Declarative MCP server builder
  #
  # Supports three invocation patterns:
  #   1. Flake ref: `nix run <flakeRef> -- [args]`  (for non-nixpkgs flakes)
  #   2. Store path: `<pkg>/bin/<binary> [args]`     (for nixpkgs packages)
  #   3. Remote URL: SSE/HTTP endpoint               (for hosted MCP servers)
  #
  # Exactly one of { flakeRef, command, url } must be provided.
  # ---------------------------------------------------------------------------
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

  # ---------------------------------------------------------------------------
  # Source definitions
  # ---------------------------------------------------------------------------

  wshobsonAgents = mkOpencodeSource {
    name = "wshobson-agents";
    src = pkgs.fetchFromGitHub {
      owner = "wshobson";
      repo = "agents";
      rev = "1ad2f007d5e9ec822a2d79e727ac1dcdf5f66f11";
      hash = "sha256-bWrT+N64nHKaJKtoluhLYGz72H6Oqht4k3HwWGU59Uc=";
    };
    patchRules = [ "^model: " ];
    components = {
      agents = [
        "plugins/backend-development/agents"
        "plugins/business-analytics/agents"
        "plugins/cloud-infrastructure/agents"
        "plugins/code-documentation/agents"
        "plugins/data-engineering/agents"
        "plugins/database-design/agents"
        "plugins/javascript-typescript/agents"
        "plugins/security-scanning/agents"
        "plugins/startup-business-analyst/agents"
        "plugins/systems-programming/agents"
      ];
      skills = [
        "plugins/backend-development/skills"
        "plugins/business-analytics/skills"
        "plugins/cloud-infrastructure/skills"
        "plugins/data-engineering/skills"
        "plugins/database-design/skills"
        "plugins/javascript-typescript/skills"
        "plugins/security-scanning/skills"
        "plugins/startup-business-analyst/skills"
        "plugins/systems-programming/skills"
      ];
      commands = [
        "plugins/backend-development/commands"
        "plugins/code-documentation/commands"
        "plugins/data-engineering/commands"
        "plugins/javascript-typescript/commands"
        "plugins/security-scanning/commands"
        "plugins/startup-business-analyst/commands"
        "plugins/systems-programming/commands"
      ];
    };
  };

  dbtSkills = mkOpencodeSource {
    name = "dbt-agent-skills";
    src = pkgs.fetchFromGitHub {
      owner = "dbt-labs";
      repo = "dbt-agent-skills";
      rev = "59aa1faf061d288e76044de0bee74248b0399a55";
      hash = "sha256-wszrCm1PefAUKjWuClPBWr6ZvSOwakmfAKVR4ueuxVc=";
    };
    patchRules = [ "^user-invocable: " ];
    components = {
      skills = [ "skills" ];
    };
  };

  superpowers = mkOpencodeSource {
    name = "superpowers";
    src = pkgs.fetchFromGitHub {
      owner = "obra";
      repo = "superpowers";
      rev = "5da4156bdbdcdf98ddf7b7d1931cf9fdc76956e7"; # v5.0.5
      hash = "sha256-Yq7y6VDrREV60WpfaGsYdnWqoaS7g1hrtci4bGtgtZM=";
    };
    patchRules = [ "^model: " ];
    components = {
      agents = [ "agents" ];
      skills = [ "skills" ];
      commands = [ "commands" ];
    };
  };

  # Anthropic's official skill library — https://github.com/anthropics/skills
  # Provides skills for Claude API usage, document generation (docx, pdf, pptx,
  # xlsx), frontend design, MCP building, webapp testing, and more.
  anthropicSkills = mkOpencodeSource {
    name = "anthropic-skills";
    src = pkgs.fetchFromGitHub {
      owner = "anthropics";
      repo = "skills";
      rev = "98669c11ca63e9c81c11501e1437e5c47b556621";
      hash = "sha256-w//9LB1OVG9jlllY+VDse7Js0dn5x6Ys2vPuQACKsTM=";
    };
    patchRules = [
      "ALWAYS use `claude-opus-4-6`"
      "This is non-negotiable"
      "For the Claude model version, please use Claude Opus 4.6"
    ];
    components = {
      skills = [ "skills" ];
    };
  };

  # ---------------------------------------------------------------------------
  # mkOpencodeAttrs: Extract per-entry attrsets from an mkOpencodeSource drv
  #
  # NOTE: This uses Import From Derivation (IFD). builtins.readDir is called
  # on derivation output paths ("${drv}/agents", etc.), which forces the
  # derivation to be built during Nix evaluation rather than at build time.
  #
  # Trade-offs:
  #   - IFD is necessary because external sources (fetchFromGitHub) are opaque
  #     derivations whose output contents cannot be enumerated at eval time
  #     without building them first.
  #   - Performance: the derivation must be realised during `nix eval` / module
  #     evaluation. These are small copy-only derivations so the cost is low
  #     once cached (fixed-output fetch + trivial installPhase).
  #   - Compatibility: IFD works with both CppNix and Lix. Some CI evaluators
  #     (e.g. Hydra with restrict-eval) may reject IFD — this repo does not
  #     use Hydra, so that is acceptable.
  #
  # Produces: { agents = { name = path; ... }; skills = { ... }; commands = { ... }; }
  #
  # For agents/commands: .md files are enumerated and the .md suffix is stripped
  # from the key name.  Each value is a standalone store path produced by
  # builtins.path.  Because derivation outputs are strings (not Nix path types),
  # these CANNOT be passed through programs.opencode.agents/commands (which uses
  # lib.isPath).  Instead, external agents/commands are written directly to
  # xdg.configFile with explicit source attributes — see effectiveExternalAgents
  # and externalAgentFiles below.
  #
  # For skills: directories are copied into standalone store paths via
  # builtins.path.  The upstream HM opencode module accepts both Nix path types
  # and store-path strings for skills (it checks both lib.isPath and
  # builtins.isString with storeDir prefix), so all skills pass through
  # programs.opencode.skills directly.
  # ---------------------------------------------------------------------------
  mkOpencodeAttrs =
    drv:
    let
      # Enumerate .md files in a subdirectory, stripping the .md suffix from keys.
      # Returns { name-without-ext = "/nix/store/...-opencode-<type>-<name>"; ... }
      #
      # Each value is a store-path string produced by builtins.path.  The
      # upstream HM opencode module checks `lib.isPath` on agent/command
      # values: paths become { source = ...; } (symlinked), strings become
      # { text = ...; } (written as literal text — broken for store paths).
      #
      # Because derivation outputs can only produce strings (not Nix path
      # types), external agents/commands CANNOT be passed through
      # programs.opencode.agents/commands.  Instead, the composed config
      # below writes them directly to xdg.configFile with explicit source
      # attributes, bypassing the isPath check entirely.
      enumerateMdFiles =
        subdir:
        let
          dir = "${drv}/${subdir}";
          entries = builtins.readDir dir;
          mdEntries = lib.filterAttrs (
            name: type: (type == "regular" || type == "symlink") && lib.hasSuffix ".md" name
          ) entries;
        in
        lib.mapAttrs' (
          name: _:
          lib.nameValuePair (lib.removeSuffix ".md" name) (
            builtins.path {
              path = "${dir}/${name}";
              name = "opencode-${subdir}-${lib.removeSuffix ".md" name}";
            }
          )
        ) mdEntries;

      # Enumerate skill directories (or symlinks to directories).
      # Returns { skill-name = /nix/store/...-opencode-skill-<name>; ... }
      #
      # Each value is a Nix path produced by builtins.path, NOT a plain
      # store-path string. This distinction matters for Home Manager:
      #
      #   - String values (e.g. "${drv}/skills/foo") hit the isString branch
      #     in the HM module, which creates a recursive directory symlink.
      #     On macOS (APFS synthetic firmlink for /nix), the resulting
      #     double-hop symlink chain through the store fails to resolve.
      #
      #   - Path values hit the isPath branch, which also uses recursive
      #     directory source but with a top-level store path (single hop).
      #     builtins.path copies the directory contents into a fresh store
      #     path, avoiding the subdirectory chain that breaks on macOS.
      enumerateSkillDirs =
        let
          dir = "${drv}/skills";
          entries = builtins.readDir dir;
          dirEntries = lib.filterAttrs (
            _: type: type == "directory" || type == "symlink"
          ) entries;
        in
        lib.mapAttrs' (
          name: _:
          lib.nameValuePair name (
            builtins.path {
              path = "${dir}/${name}";
              name = "opencode-skill-${name}";
            }
          )
        ) dirEntries;
    in
    {
      agents = enumerateMdFiles "agents";
      skills = enumerateSkillDirs;
      commands = enumerateMdFiles "commands";
    };

  # ---------------------------------------------------------------------------
  # Local agents: enumerate .md files from ./agents at eval time (no IFD —
  # these are plain source paths available during evaluation).
  # ---------------------------------------------------------------------------
  localAgents =
    let
      entries = builtins.readDir ./agents;
      mdFiles = lib.filterAttrs (
        _: type: type == "regular" || type == "symlink"
      ) entries;
    in
    lib.mapAttrs' (
      name: _: lib.nameValuePair (lib.removeSuffix ".md" name) (./agents + "/${name}")
    ) mdFiles;

  # ---------------------------------------------------------------------------
  # Local skills: enumerate skill directories from ./skills at eval time.
  # ---------------------------------------------------------------------------
  localSkills =
    let
      entries = builtins.readDir ./skills;
      dirs = lib.filterAttrs (
        _: type: type == "directory" || type == "symlink"
      ) entries;
    in
    lib.mapAttrs' (name: _: lib.nameValuePair name (./skills + "/${name}")) dirs;

  # ---------------------------------------------------------------------------
  # Composed attrsets: external sources (mkDefault-priority) merged with local
  # entries (right-wins via //). Local entries listed LAST to take precedence.
  #
  # External agents/commands are store-path STRINGS (from builtins.path).
  # The upstream HM opencode module uses `lib.isPath` to decide whether to
  # create a symlink ({ source }) or write literal text ({ text }).  Since
  # derivation outputs are always strings, external agents/commands must
  # bypass programs.opencode.agents/commands and instead be written directly
  # to xdg.configFile with explicit source attributes.
  #
  # Local agents/commands are Nix PATH types (./agents + "/${name}") and
  # pass through the HM option correctly.
  #
  # Skills use a separate code path in the HM module that accepts both
  # paths and store-path strings, so all skills go through the option.
  # ---------------------------------------------------------------------------
  externalAgents =
    (mkOpencodeAttrs wshobsonAgents).agents // (mkOpencodeAttrs superpowers).agents;
  externalSkills =
    (mkOpencodeAttrs wshobsonAgents).skills
    // (mkOpencodeAttrs dbtSkills).skills
    // (mkOpencodeAttrs superpowers).skills
    // (mkOpencodeAttrs anthropicSkills).skills;
  externalCommands =
    (mkOpencodeAttrs wshobsonAgents).commands
    // (mkOpencodeAttrs superpowers).commands;

  composedSkillAttrs = externalSkills // localSkills;

  # External agents/commands that overlap with local entries are dropped
  # (local takes precedence via removeAttrs).
  effectiveExternalAgents = removeAttrs externalAgents (
    builtins.attrNames localAgents
  );
  effectiveExternalCommands = externalCommands;

  # Convert external agents/commands to xdg.configFile entries with explicit
  # source attributes, creating proper symlinks instead of literal text files.
  externalAgentFiles = lib.mapAttrs' (
    name: storePath:
    lib.nameValuePair "opencode/agents/${name}.md" { source = storePath; }
  ) effectiveExternalAgents;

  externalCommandFiles = lib.mapAttrs' (
    name: storePath:
    lib.nameValuePair "opencode/commands/${name}.md" { source = storePath; }
  ) effectiveExternalCommands;

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
      name = "github";
      command = [ "${pkgs.github-mcp-server}/bin/github-mcp-server" ];
      args = [ "stdio" ];
    })

    # Terraform registry: provider docs, resource schemas, module search
    (mkMcpServer {
      name = "terraform";
      command = [ "${pkgs.terraform-mcp-server}/bin/terraform-mcp-server" ];
      args = [ "stdio" ];
    })

    # Context7: up-to-date library documentation & code examples (remote/SSE)
    (mkMcpServer {
      name = "context7";
      url = "https://mcp.context7.com/mcp";
    })
  ];
in
{
  programs.opencode = {
    enable = true;

    # Local agents/commands are Nix path types and pass through the HM
    # option's lib.isPath check correctly (creating symlinks).
    # External agents/commands are handled via xdg.configFile below.
    agents = localAgents;
    skills = composedSkillAttrs;
    commands = { };

    # Global agent instructions written to $XDG_CONFIG_HOME/opencode/AGENTS.md.
    # All agents automatically receive these rules as baseline context.
    #
    # Commit policy references:
    #   - Conventional Commits: https://www.conventionalcommits.org
    #   - Assisted-by footer: https://xeiaso.net/notes/2025/assisted-by-footer/
    #   - Conform config: packages/text/conform-config/default.nix
    #   - Git-cliff config: packages/text/git-cliff-config/default.nix
    rules = ''
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
        "@simonwjackson/opencode-direnv@f257fa7f7e19ea8722fdfe546c2cb8b736d9387d"
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
        };
      };
    };
  };

  # ---------------------------------------------------------------------------
  # External agents/commands: bypass programs.opencode.agents/commands (which
  # require Nix path types) and write xdg.configFile entries directly with
  # explicit source attributes.  This creates proper symlinks to the store
  # paths produced by builtins.path, rather than writing the path string as
  # literal file content.
  # ---------------------------------------------------------------------------
  xdg.configFile = externalAgentFiles // externalCommandFiles;
}
