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
  # from the key name (upstream module re-adds it when generating xdg entries).
  #
  # For skills: directories (and symlinks) are enumerated as-is. The values are
  # store-path strings ("${drv}/skills/foo") so the upstream module treats them
  # as recursive directory sources.
  # ---------------------------------------------------------------------------
  mkOpencodeAttrs =
    drv:
    let
      # Enumerate .md files in a subdirectory, stripping the .md suffix from keys.
      # Returns { name-without-ext = "${drv}/<subdir>/<name>.md"; ... }
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
          name: _: lib.nameValuePair (lib.removeSuffix ".md" name) (dir + "/${name}")
        ) mdEntries;

      # Enumerate skill directories (or symlinks to directories).
      # Returns { skill-name = "${drv}/skills/skill-name"; ... }
      # Values are store-path strings so the upstream HM module will treat
      # them as recursive directory sources (the isString + hasPrefix storeDir
      # branch in the upstream config).
      enumerateSkillDirs =
        let
          dir = "${drv}/skills";
          entries = builtins.readDir dir;
          dirEntries = lib.filterAttrs (
            _: type: type == "directory" || type == "symlink"
          ) entries;
        in
        lib.mapAttrs' (name: _: lib.nameValuePair name "${dir}/${name}") dirEntries;
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
  # ---------------------------------------------------------------------------
  externalAgents = (mkOpencodeAttrs wshobsonAgents).agents;
  externalSkills =
    (mkOpencodeAttrs wshobsonAgents).skills // (mkOpencodeAttrs dbtSkills).skills;
  externalCommands = (mkOpencodeAttrs wshobsonAgents).commands;

  composedAgentAttrs = externalAgents // localAgents;
  composedSkillAttrs = externalSkills // localSkills;
  composedCommandAttrs = externalCommands;

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

    # Composed attrsets: upstream HM module handles xdg.configFile placement.
    # Each agent/command entry is a path to an .md file; each skill entry is
    # a store-path string pointing to a directory with SKILL.md inside.
    agents = composedAgentAttrs;
    skills = composedSkillAttrs;
    commands = composedCommandAttrs;

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

      ## Nix-First Tooling & Execution

      - All tool calls MUST use `nix run` or `nix shell` commands as the base.
      - Any agents, skills, or tools that call for a binary without qualifying how to run it MUST be assumed to mean execution via Nix. Never assume packages are installed locally or globally.
      - **Package Discovery & Validation:**
        1. First attempt: Search for the required package using the available `nixos` MCP server.
        2. Fallback: Use web search to find packages described in the official `nixpkgs` repository.
        3. If a tool is required that is not already defined in `nixpkgs`, **STOP** and ask the user for clarification or pathways forward.
      - Use `nixfmt` to format all `.nix` files before committing.

      ## Code Quality

      - Run `nix flake check` or the appropriate build command before considering work complete.
      - Read the relevant skill instructions (e.g., `nix-ops`) for build/test/lint commands.
      - Do not remove user data or critical configurations without explicit instruction.
    '';

    settings = {
      plugin = [ ];

      inherit mcp;

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
