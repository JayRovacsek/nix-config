---
name: working-with-nix
version: "1.0.0"
description: Use when working with Nix, NixOS, or Lix and authoritative reference material is needed — configuring or administering NixOS, authoring NixOS modules, packaging software in nixpkgs style, running repo build/lint workflows, or looking up nix CLI flags, nix.conf settings, and experimental features. Triggers on offline Nix/Lix docs lookup, module authoring, mkOption/option types, fetchers/stdenv/overrides, CLI flag verification, and flake build/lint commands.
user-invocable: true
---

# Working with Nix

## Overview

**Core principle: offline-first.** The authoritative Nix documentation — the Lix
reference manual, the NixOS manual, and the nixpkgs manual — is already on disk in
the Nix store. Discover it, don't guess, and don't reach for the web. Every fact in
this skill was distilled from those local sources, and every source location is
expressed as a repeatable discovery method, never a cached store path.

Use this skill to:

- Answer "how do I do X on NixOS" from local docs (configuration, administration).
- Author or refactor NixOS modules (option declarations, types, merge semantics).
- Write nixpkgs-style expressions (fetchers, stdenv, overrides, overlays).
- Verify a CLI flag or `nix.conf` setting exists before using it.
- Run this repo's build, lint, and tool-discovery workflow (builds, statix, deadnix,
  REPL sessions).

This skill absorbs the repo's `nix-ops`, `nix-tooling-workflow`, and
`nixos-test-dev` content — no sibling skill lookups needed.

## Discovering the docs

Store paths change on every nixpkgs update — never hardcode a hashed
`/nix/store/<hash>-...` path. Re-derive every location at runtime:

| Source | Discovery method |
|---|---|
| nix binary (Lix) | `command -v nix` first (direnv may not expose it); fallback glob `echo /nix/store/*-lix-*/bin/nix` (bash glob, no hash) and pick the highest version. A separate CppNix `nix-2.34.x` may also exist — choose the `lix-*` path for Lix docs |
| nixpkgs source tree | `<nix-binary> eval --raw --impure --expr '(builtins.getFlake "<abs-path-to-this-repo>").inputs.nixpkgs.outPath'` — resolves from flake.lock without network |
| Lix man pages | Take the chosen binary's store dir and replace `bin/nix` with `share/man`; `man1/` holds legacy `nix-*` plus new-style `nix3-*` (~126 gz pages), `man5/` holds `nix.conf.5.gz` and `nix-profiles.5.gz`. Some lix versions ship man pages in a separate `-lix-<ver>-man` output instead — the fallback glob below matches those too |
| Lix mdBook docs | Glob `echo /nix/store/*-lix-*-doc`; manual under `share/doc/nix/manual/` with `command-ref/new-cli/`, `language/`, `package-management/`, `advanced-topics/`, `glossary.html`, and `print.html` (whole manual concatenated) |
| flake registry | `share/flake-registry.json` under the same lix store dir (read with `jq`); maps short indirect names like `nixpkgs` so `nix build nixpkgs#hello` resolves offline |
| Pre-built NixOS manual HTML | Glob `echo /nix/store/*-nixos-manual-html` — present from prior system builds |
| Store browsing without a shell | nixos MCP `nix` tool with `action=store`, `type=ls\|read` |

Inside the nixpkgs outPath: `nixos/doc/manual/` holds the NixOS manual markdown
(`configuration/`, `development/`, `administration/`, `installation/`,
`release-notes/`); `doc/` holds the pkgs manual markdown (`using/`, `functions/`,
`build-helpers/`, `stdenv/`, `packages/`, `languages-frameworks/`,
`module-system/`, `hooks/`, `styleguide.md`, `function-catalog.json`).

### Shell caveats in this environment

| Caveat | Workaround |
|---|---|
| Plain PATH lacks coreutils (`ls`, `head`, `cat`, `sed`, `sort`, `wc`, `od`, `uniq`, `basename`) | Use bash builtins (`echo` globs), `rg` (`--max-count` instead of `head`, `-a` for binary-ish files), `jq`, `bat`; `command -v` works |
| Man pages are gzip-compressed and `gzip` is not on PATH | Resolve it via glob and loop over candidates until one runs (some globbed candidates fail with a missing-loader error): see recipe 4 |
| Decompressed roff contains null bytes | The read tool rejects it as binary; pipe through `rg -a` |
| mdBook pages carry ~180 lines of chrome before `<main>` | Grep for `<code>` / `<h1 id=...>` or extract the content section rather than reading whole files |

## Recipes

Concrete, copy-pasteable discovery steps (replace `<repo>` with the absolute path to
this repository):

```bash
# 1. Locate the nix binary (Lix); if the glob returns several, pick the highest version
NIX=$(command -v nix || echo /nix/store/*-lix-*/bin/nix)

# 2. Resolve the nixpkgs source tree from flake.lock (no network)
"$NIX" eval --raw --impure --expr '(builtins.getFlake "<repo>").inputs.nixpkgs.outPath'

# 3. List the Lix man pages (derive from the binary's store dir)
#    e.g. <store-dir-of-nix-binary>/share/man/man1 — or glob:
echo /nix/store/*-lix-*/share/man/man1

# 4. Decompress a man page and search it (roff has null bytes → use rg -a).
#    gzip is not on PATH; loop over globbed candidates — a failing candidate
#    yields no rg match, so the loop continues to the next one:
for g in /nix/store/*-gzip-*/bin/gzip; do
  "$g" -dc <man-dir>/man1/nix3-build.1.gz 2>/dev/null \
    | rg -a --max-count 20 'Options|--out-link' && break
done

# 5. Whole-manual flag/setting lookup in one grep
rg -a --max-count 20 'experimental-features' <doc-dir>/print.html

# 6. Locate a lib function's source file
rg 'lib.strings' <nixpkgs-outPath>/doc/function-catalog.json
```

Without a shell, use the nixos MCP `nix` tool: `action=store`, `type=ls` to list a
store directory, `type=read` to read a file (e.g. the mdBook page or
`flake-registry.json`).

## Quick reference — where to look

| Question type | Reference file | Underlying source |
|---|---|---|
| NixOS configuration: syntax, packages, profiles, users, networking, file systems, kernel/GPU, systemd services, rollback, GC, containers, impermanent state | [references/nixos-configuration.md](references/nixos-configuration.md) | `nixos/doc/manual/configuration/`, `administration/` |
| Module authoring: option declarations, option types, `mkIf`/`mkMerge`, freeform modules, settings options, assertions, meta, activation scripts, unit handling, test essentials | [references/module-system.md](references/module-system.md) | `nixos/doc/manual/development/`, pkgs `doc/module-system/` |
| Packaging: nixpkgs config keys, overlays, overrides, platform tiers, `lib` functions, fetchers, stdenv phases, dependency placement, trivial builders, meta conventions | [references/packaging.md](references/packaging.md) | pkgs `doc/using`, `doc/build-helpers`, `doc/stdenv`, `doc/functions`, `doc/packages` |
| CLI: command groups, key flags, common options, `nix.conf` settings catalogue, experimental features, store URLs, Lix vs CppNix | [references/cli-reference.md](references/cli-reference.md) | Lix man pages (`man1`, `man5`), mdBook `command-ref/` |
| Repo operations: tool discovery priority, build/lint commands, Lix detection, persistent REPL via tmux | [references/repo-operations.md](references/repo-operations.md) | Repo conventions (rolled in from `nix-ops`, `nix-tooling-workflow`) |

## Verification workflow

1. Identify the question type from the table above and open the matching reference.
2. Before using a flag or setting name not listed there, grep the relevant
   `nix3-<cmd>.html` (or `nix3-<cmd>.1.gz`) for `--flag`, or the decompressed
   `nix.conf.5` for the setting name. For a whole-manual sweep, grep `print.html`
   — it concatenates every page into one file.
3. To locate a `lib.*` function, consult `function-catalog.json` in the pkgs doc
   directory to map the namespace to its source file, then read that file.
4. Only fall back to the web when the offline sources genuinely lack the answer.

## Common mistakes

| Mistake | Fix |
|---|---|
| Hardcoding a hashed `/nix/store/<hash>-...` path | Re-derive via the discovery methods above; paths change on every nixpkgs update |
| Using a CLI flag without verifying it exists | Grep the `nix3-<cmd>` man page or mdBook page for `--flag` first — avoids hallucinated flags |
| `nix3-*` subcommand errors out | `nix-command` must be enabled via `experimental-features` or `--extra-experimental-features nix-command` |
| `gzip -c` on a man page yields binary | Use `gzip -dc` (force decompress) |
| Reading decompressed roff directly | It contains null bytes; pipe through `rg -a` |
| Bare `if config.x then ... else ...` at the top of `config` | Wrap in `mkIf` — it pushes the conditional into individual definitions and avoids infinite recursion |
| `builtins.fetch*` in nixpkgs | Use `pkgs.fetch*` (fixed-output, downloaded at build time); built-ins download at eval time and are disallowed |
| Changing a fetcher param without updating the hash | Any param change (url, stripRoot, etc.) requires recomputing `hash` |
| `--replace` in `substitute` | Use `--replace-fail` / `--replace-warn` / `--replace-quiet` |
| `nixos.thunderbird` in declarative config | Use `pkgs.<name>`; the `nixos.` prefix works only in CLI tools |
| `systemctl --user enable` on a store path | Symlink from `/run/current-system/sw/lib/systemd/user/...` into the `.wants/` dir; GC breaks direct enables |
| Forgetting `...` in a module argument list | Always keep `...` so new module-system arguments don't break evaluation |
| Storing WiFi PSKs or keys inline in config | Use `secretsFile`/`ext:` or a `/run/secrets` file; inline values land in the store readable by all |
| Running `nix-collect-garbage -d` without warning | It deletes old roots and destroys rollback ability — warn first |
| Adding a bare package when a NixOS service module exists | Check for a module first (D-Bus/systemd registration) before `environment.systemPackages` |
| `overrideDerivation` in nixpkgs | Prefer `overrideAttrs` (fixed-point form); `overrideDerivation` evaluates the derivation first and breaks `separateDebugInfo` |

## Red flags — STOP and use the offline docs

- About to web-search a `nix.conf` setting name or CLI flag → grep the local
  `nix.conf.5` / `nix3-<cmd>` page first.
- About to paste a `/nix/store/<hash>-...` path from memory or a previous session →
  re-derive it; hashes change on every nixpkgs update.
- About to invent an option type (`anything`) → check `lib/types.nix` or the
  option-types catalogue here.
- About to guess a `nixpkgs.config` key → grep `doc/using/configuration.chapter.md`
  for the exact name.
- About to read a whole mdBook HTML page → grep for the content section instead
  (~180 lines of chrome per page).

**Violating the letter of the offline-first rule is violating its spirit.** The docs
are on disk; the web fallback is only for genuine gaps.
