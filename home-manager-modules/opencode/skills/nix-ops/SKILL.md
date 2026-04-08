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
prefer `nix repl` via `tui-use`** over one-shot `nix eval` commands.

The REPL keeps the flake loaded in memory, so subsequent evaluations are near-instant
instead of re-parsing the entire flake each time. This matters in a large
NixOS configuration repository.

### Prerequisites

Before using the REPL workflow, verify `tui-use` is available:

```bash
tui-use --version
```

If that fails (command not found or error), fall back to one-shot `nix eval`
commands described in the "Fallback" section below.

### Starting a REPL Session

```bash
# Start nix repl and load the current flake
tui-use start --label nix-repl "nix repl .#"
tui-use wait --text "nix-repl>"
tui-use snapshot                               # confirm load succeeded
```

This loads all flake outputs into scope. The snapshot shows how many variables
were added. You can now tab-complete and evaluate any attribute path directly.

### Evaluating Expressions

```bash
# Type an expression and press enter
tui-use type "nixosConfigurations.ditto.config.networking.hostName\n"
tui-use wait --text "nix-repl>"
tui-use snapshot                               # read the result

# Inspect option types
tui-use type ":t nixosConfigurations.ditto.config.services\n"
tui-use wait --text "nix-repl>"
tui-use snapshot

# List attribute names
tui-use type "builtins.attrNames packages.aarch64-darwin\n"
tui-use wait --text "nix-repl>"
tui-use snapshot

# Test an expression fragment
tui-use type "let x = 1 + 2; in x\n"
tui-use wait --text "nix-repl>"
tui-use snapshot
```

After each `type`, call `wait` to block until the REPL has finished evaluating,
then `snapshot` to read the result. Without `snapshot` you will not see the output.

### Reading Output

```bash
# Take a snapshot to read the current screen
tui-use snapshot

# If output is long, scroll up to see earlier content
tui-use scrollup 10
tui-use snapshot

# Search for a specific pattern in the screen
tui-use find "hostName"
```

### REPL Built-in Commands

These are typed inside the REPL session (via `tui-use type`):

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

```bash
tui-use type ":r\n"
tui-use wait --text "nix-repl>"
```

### Cleaning Up

Always kill the session when finished:

```bash
tui-use type ":q\n"
tui-use kill                                   # idempotent — safe even if REPL already exited
```

### Fallback: One-Shot Evaluation

Use `nix eval` when `tui-use` is unavailable or for a single quick check
where starting a REPL is not worthwhile:

```bash
nix eval .#nixosConfigurations.ditto.config.networking.hostName
nix eval --json .#packages.aarch64-darwin.tui-use.meta
```

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

1.  **Explore:** Start a `nix repl` session via `tui-use` (or use `nix eval` if `tui-use` is unavailable) to understand the flake structure and test expressions interactively.
2.  **Edit:** Modify `.nix` files.
3.  **Reload:** Use `:r` in the REPL to pick up changes without restarting.
4.  **Format:** Run `nix fmt`.
5.  **Verify:** Run `statix check` and `deadnix`.
6.  **Build:** Verify the build succeeds before asking the user to apply/switch.
