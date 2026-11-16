# Nix Operations Skill

Use this skill when you need to build, test, lint, format, or explore code in this Nix configuration repository.

## Prefer Lix Over CppNix

This repository prefers [Lix](https://lix.systems) — a community fork of Nix —
wherever it is available. Lix is invoked via the same `nix` binary; it is a
drop-in replacement. All commands in this skill (`nix build`, `nix eval`,
`nix repl`, `nix flake check`, etc.) work identically under Lix.

### Detection

Run `nix --version` and inspect the first line of output:

| Output contains           | Implementation |
| ------------------------- | -------------- |
| `nix (Lix, like Nix) ...` | Lix            |
| `nix (Nix) ...`           | CppNix         |

```bash
# Quick one-liner: exits 0 if Lix, 1 if CppNix
nix --version 2>&1 | grep -q "Lix"
```

If Lix is the active implementation, no action is needed — just use `nix` as
normal. If CppNix is detected and Lix is available elsewhere on the system
(e.g. via `nix-shell` or an alternative profile), prefer switching to Lix
before proceeding. If Lix is not available at all, CppNix is an acceptable
fallback — do not block on its absence.

## Interactive Nix REPL (Strongest Preference)

When you need to evaluate Nix expressions — inspecting attribute paths, checking
option types, testing expression fragments, exploring flake outputs — **always
prefer `nix repl`** over one-shot `nix eval` commands.

The REPL keeps the flake loaded in memory, so subsequent evaluations are near-instant
instead of re-parsing the entire flake each time. This matters in a large
NixOS configuration repository.

### Agent-Centric Workflow

LLM agents can leverage the REPL to perform stateful, multi-step exploration.
Instead of multiple expensive `nix eval` calls, an agent can initiate a REPL session
to maintain context and speed.

#### 1. Persistent Session Interaction (Recommended)

An agent can interact with a persistent REPL session using `tmux`. This allows
the agent to start a session in the background and send commands via `send-keys`.

```bash
# Start a detached REPL session
tmux new-session -d -s nix-repl 'nix repl .#'

# Send a command to the session
tmux send-keys -t nix-repl "nixosConfigurations.ditto.config.networking.hostName" Enter

# Inspect option types
tmux send-keys -t nix-repl ":t nixosConfigurations.ditto.config.services" Enter

# Reload files after edits
tmux send-keys -t nix-repl ":r" Enter

# Capture the output from the session to read it
tmux capture-pane -t nix-repl -p

# Exit the session
tmux send-keys -t nix-repl ":q" Enter
```

#### 2. Fallback: One-Shot Evaluation

For single-shot queries where a REPL session overhead is unnecessary, use `nix eval`.

```bash
nix eval .#nixosConfigurations.ditto.config.networking.hostName
nix eval --json .#packages.aarch64-darwin.meta
```

### REPL Built-in Commands

These are typed inside the REPL session:

| Command     | Purpose                                       |
| ----------- | --------------------------------------------- |
| `:t <expr>` | Show the type of an expression                |
| `:p <expr>` | Pretty-print a value (forces full evaluation) |
| `:l <path>` | Load a Nix file into scope                    |
| `:lf <ref>` | Load a flake reference into scope             |
| `:r`        | Reload all loaded files (after edits)         |
| `:?`        | Show help                                     |
| `:q`        | Quit the REPL                                 |

After editing `.nix` files, use `:r` to reload without restarting the session.
Note: `:r` reloads files already in scope. If you add entirely new imports that
were not part of the original evaluation, restart the REPL instead.

## Build Commands

- **Build a Host System:**

  ```bash
  # Replace <hostname> with the target host (e.g., ditto, alakazam)
  nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel
  ```

- **Apply Configuration (Local):**

  ```bash
  nixos-rebuild test --flake .\# --sudo
  ```

- **Build Specific Package:**

  ```bash
  nix build .#<package_name>
  ```

- **Build Specific Package on Alternative Arch:**

  ```bash
  nix build .#packages.<system>.<package_name>
  ```

- **Dry Run:**
  For complex changes, use `nixos-rebuild build --flake .#<host>` to ensure configuration builds without switching.

## Linting & Formatting

- **Run All Checks (Recommended):**

  ```bash
  nix flake check
  ```

  This runs all configured hooks including formatting, linting, and package builds.

- **Auto-Format Code:**

  ```bash
  nix fmt
  ```

  Uses `nixfmt` with a width of 80. Always run this before committing.

- **Manual Linting:**
  - **Dead Code:** `deadnix .` (or `deadnix --edit .` to auto-remove)
  - **Anti-patterns:** `statix check .` (or `statix fix .` to auto-fix)
  - **Typos:** `typos`

## Testing

- **NixOS Tests:**
  Tests are often integrated into `flake.nix` checks. Run `nix flake check` to execute them.

## Development Workflow

1.  **Explore:** Use a persistent `nix repl` session (e.g., via `tmux send-keys`) to understand the flake structure and test expressions interactively.
2.  **Edit:** Modify `.nix` files.
3.  **Reload:** Use `:r` in the REPL to pick up changes without restarting.
4.  **Format:** Run `nix fmt`.
5.  **Verify:** Run `statix check` and `deadnix`.
6.  **Build:** Verify the build succeeds before asking the user to apply/switch.
