---
name: conventional-commit-format
version: "1.0.0"
description: Enforces Conventional Commits with local repository norm detection, falling back to standard conventional commit defaults. Includes casing rules, header constraints, and mandatory Assisted-by attribution footer for AI-assisted contributions.
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
---

# Conventional Commit Format Skill

This skill enforces a structured commit message format. Every commit message MUST follow the structure defined below. The skill first checks for local repository norms (conform configs, commitlint, gitlint, etc.) and falls back to standard Conventional Commits defaults when none are found.

## Commit Message Format

Every commit message MUST follow this structure:

```
<type>(<scope>): <description>

[optional body — describe the "why", not the "what"]

Assisted-by: <model name> via <tool name>
```

### Casing

The casing depends on local repository configuration. Check for `.conform.yaml` (look for `case` rules), `commitlint.config.*`, or `.gitlint` to determine casing requirements. If no local rules exist, apply these defaults:

- Use the **imperative mood** ("add feature" not "added feature")
- Do NOT end the description with a period
- Do NOT capitalise the first letter of the description unless it is a proper noun

### Types and Scopes

First, check for local repository configuration:

| Config file           | What it defines                                  |
| --------------------- | ------------------------------------------------ |
| `.conform.yaml`       | Allowed types, scopes, and header rules          |
| `cliff.toml`          | Git-cliff changelog types and scopes             |
| `commitlint.config.*` | Allowed types via `@commitlint/config-*` presets |
| `.gitlint`            | Custom gitlint rules                             |

Read the relevant config file and use only the types and scopes listed there.

**Fallback to standard Conventional Commits types** when no local configuration is found:

| Type       | Purpose                                             |
| ---------- | --------------------------------------------------- |
| `build`    | Build system changes                                |
| `chore`    | Maintenance, tooling, lockfile updates              |
| `ci`       | CI/CD configuration                                 |
| `docs`     | Documentation                                       |
| `feat`     | New features                                        |
| `fix`      | Bug fixes                                           |
| `perf`     | Performance improvements                            |
| `refactor` | Code changes that neither add features nor fix bugs |
| `release`  | Version bumps                                       |
| `style`    | Formatting, linting, style changes                  |
| `test`     | Test-related changes                                |

A scope is required when the change is clearly confined to one area; omit it only when the change genuinely spans multiple areas.

### Header Rules

Check local configuration for header constraints. If none are found, apply these defaults:

- Maximum length: **140 characters** (type + scope + description combined)
- Use the **imperative mood** ("add feature" not "added feature")
- Do NOT end the description with a period
- Do NOT capitalise the first letter of the description

## AI-Assisted Attribution

Every commit follows the `Assisted-by` commit footer convention (per [Xe Iaso](https://xeiaso.net/notes/2025/assisted-by-footer/) and [Fedora's AI-Assisted Contributions Policy](https://docs.fedoraproject.org/en-US/council/policy/ai-contribution-policy/)) to ensure transparent, machine-readable disclosure of AI tool usage.

The `Assisted-by` trailer is **mandatory** on every commit an AI agent creates.

1. Use the **actual model name** you are running as (check your system prompt or model identifier).
2. Use **OpenCode** as the tool name (since all agents run inside OpenCode).
3. If multiple models contributed, include multiple `Assisted-by` lines.
4. The trailer must be the **last line(s)** of the commit message.
5. Do NOT fabricate model names — use only your real model identifier.
6. Do NOT omit this trailer, even for trivial commits (formatting, typo fixes, etc.).

## Examples

```
feat(home-manager-modules): add opencode rules for commit attribution

refactor(lib): simplify host generation logic

fix(modules,linux): resolve grafana service breakage after upgrade

chore(flake): update flake lock & deduplicate inputs
```

### Full commit with body and attribution

```
feat(home-manager-modules): add opencode global agent rules

add programs.opencode.rules with conventional commit enforcement,
lowercase policy, and assisted-by trailer requirement so all ai
agents produce consistent, machine-readable commit messages.

Assisted-by: Claude Opus 4 via OpenCode
```
