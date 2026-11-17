# Repo Operations — Tool Discovery, Builds, Linting, REPL

Distilled from this repository's `nix-ops` and `nix-tooling-workflow` conventions.
General CLI flag lookup lives in `cli-reference.md`; this file covers the repo's
own build, lint, and tool-discovery workflow.

## Tool discovery priority

| Step | Action |
|---|---|
| 1. Prefer local tools | OpenCode commonly runs inside a `direnv` shell that already provides binaries on `$PATH`. Check `command -v <tool>`; use directly if found |
| 2. Fall back to Nix | `nix run nixpkgs#<package> -- <args>` or `nix shell nixpkgs#<package> -c <cmd>` |
| 3. Package discovery | Search via the nixos MCP server (package/option search for NixOS, Home Manager, nix-darwin) before web search |
| 4. Stop and ask | If the tool is not in nixpkgs, not local, and the correct package name is unclear — STOP and ask the user |

## Lix detection

Prefer Lix over CppNix where available; the `nix` binary is a drop-in replacement.

| Check | Result |
|---|---|
| `nix --version` contains `nix (Lix, like Nix)` | Lix — proceed as normal |
| `nix --version` contains `nix (Nix)` | CppNix — if Lix exists elsewhere on the system (e.g. an alternative profile), prefer switching; if Lix is absent entirely, CppNix is an acceptable fallback — do not block |

One-liner: `nix --version 2>&1 | grep -q "Lix"` (exit 0 means Lix).

## Build commands

| Task | Command |
|---|---|
| Build a host system | `nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel` |
| Apply configuration locally | `nixos-rebuild test --flake .#<host> --sudo` |
| Build a specific package | `nix build .#<package>` |
| Build on an alternative arch | `nix build .#packages.<system>.<package>` |
| Dry-run complex changes | `nixos-rebuild build --flake .#<host>` (builds without switching) |
| Run all configured checks | `nix flake check` (formatting, linting, package builds) |

NEVER guess build targets; read `flake.nix` `outputs` to find them.

## Linting & formatting

| Tool | Command | Purpose |
|---|---|---|
| nixfmt | `nix fmt` (or `nixfmt <file>`) | Format all `.nix` files (80-column width); always run before committing |
| statix | `statix check .` / `statix fix .` | Anti-pattern detection |
| deadnix | `deadnix .` / `deadnix --edit .` | Dead-code removal |
| typos | `typos` | Typo detection |

## Persistent REPL via tmux

Prefer `nix repl` over one-shot `nix eval` for multi-step exploration — the flake
stays loaded in memory, so subsequent evaluations skip re-parsing (this matters in
a large configuration repo).

| Step | Command |
|---|---|
| Start detached session | `tmux new-session -d -s nix-repl 'nix repl .#'` |
| Send a command | `tmux send-keys -t nix-repl "<expr>" Enter` |
| Inspect a type | `tmux send-keys -t nix-repl ":t <expr>" Enter` |
| Reload after edits | `tmux send-keys -t nix-repl ":r" Enter` (reloads files already in scope; restart for brand-new imports) |
| Capture output | `tmux capture-pane -t nix-repl -p` |
| Exit | `tmux send-keys -t nix-repl ":q" Enter` |

Fallback one-shot: `nix eval .#nixosConfigurations.<host>.config.networking.hostName`.

## Development workflow loop

1. **Explore** — persistent REPL session (tmux) to understand the flake and test expressions.
2. **Edit** — modify `.nix` files.
3. **Reload** — `:r` in the REPL picks up changes without restarting.
4. **Format** — `nix fmt`.
5. **Verify** — `statix check` and `deadnix`.
6. **Build** — verify the build succeeds before asking the user to apply/switch.
