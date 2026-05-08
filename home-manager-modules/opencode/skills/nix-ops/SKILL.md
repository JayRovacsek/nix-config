---
name: nix-ops
description: Use when building, testing, linting, formatting, exploring NixOS/Darwin configurations, validating flake outputs via nix repl, or debugging evaluation errors in this Nix configuration repository
---

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

## Interactive Nix REPL

**REQUIRED SUB-SKILL:** Use `superpowers:tui-use` for all interactive REPL sessions. The REPL
keeps the flake loaded in memory, so subsequent evaluations are near-instant
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

### Session Management

Always manage session lifecycle explicitly. A REPL session should be started
when you need interactive evaluation, kept alive while you do multiple queries,
and killed when you are done.

```bash
# Start
tui-use start --label nix-repl "nix repl .#"
tui-use wait --text "nix-repl>"
tui-use snapshot

# After done
tui-use type ":q\n"
tui-use kill
```

If you need to run multiple independent queries, keep a single REPL session
alive rather than restarting. Killing and restarting is only needed when the
flake has been reloaded with `:r` and you suspect stale state, or when the
session has become unresponsive.

To check session status:

```bash
tui-use info
```

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

### Advanced tui-use Patterns

#### Wait Strategies

The `wait` command is the primary way to observe terminal state. It blocks until
the screen changes or a timeout occurs (default 3000ms).

```bash
tui-use wait                                # Wait for any screen change
tui-use wait --text "nix-repl>"             # Wait until screen contains pattern
tui-use wait 5000                           # Custom timeout in milliseconds
tui-use wait --format json                  # JSON output for programmatic access
```

Always call `wait` before `type` to ensure the program is ready to accept input.
If the REPL is evaluating a large expression, increase the timeout:

```bash
tui-use wait 10000                          # 10 second timeout for large evals
```

#### Reading Output

```bash
# Take a snapshot to read the current screen
tui-use snapshot

# If output is long, scroll up to see earlier content
tui-use scrollup 10
tui-use snapshot

# Search for a specific pattern in the screen
tui-use find "hostName"
```

#### Error Recovery

If the REPL becomes unresponsive or times out:

```bash
# Check if session is still running
tui-use info

# If exited, start a new session
tui-use start --label nix-repl "nix repl .#"
tui-use wait --text "nix-repl>"
tui-use snapshot

# If running but stuck, send Ctrl+C to interrupt
tui-use press ctrl-c
tui-use wait --text "nix-repl>"
```

#### Snapshot Techniques

Use `snapshot` to capture the current terminal state. Use `--format json` when
you need to programmatically inspect the output:

```bash
tui-use snapshot --format json
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

### Attribute Path Navigation

Use `.` (dot) to navigate deeply into nested attributes. For safe access
(returning null instead of an error when the attribute is missing), use
`builtins.attrByPath` or the `or` operator.

```bash
# Navigate down into nested attributes
tui-use type "nixosConfigurations.ditto.config\n"
tui-use wait --text "nix-repl>"
tui-use snapshot

# Chain attribute access
tui-use type "nixosConfigurations.ditto.config.networking\n"
tui-use wait --text "nix-repl>"
tui-use snapshot

# Safe attribute access using builtins.attrByPath
tui-use type "builtins.attrByPath [\"nixosConfigurations\" \"ditto\" \"config\" \"services\" \"sshd\"] \"default\"\n"
tui-use wait --text "nix-repl>"
tui-use snapshot

# Safe access using the or operator
tui-use type "nixosConfigurations.ditto.config.services.sshd or null\n"
tui-use wait --text "nix-repl>"
tui-use snapshot
```

This avoids the need to type long attribute paths and makes exploration faster.

### Built-in Functions in REPL

The REPL supports all Nix built-in functions. Use them interactively:

```bash
# Get attribute names
tui-use type "builtins.attrNames nixosConfigurations\n"
tui-use wait --text "nix-repl>"
tui-use snapshot

# Access nested attributes safely
tui-use type "builtins.attrByPath [\"nixosConfigurations\" \"ditto\" \"config\" \"networking\" \"hostName\"] \"default\"\n"
tui-use wait --text "nix-repl>"
tui-use snapshot

# Intersect attribute sets
tui-use type "let a = { foo = 1; bar = 2; }; let b = { bar = 3; baz = 4; }; in builtins.intersectAttrs (name: true) a b\n"
tui-use wait --text "nix-repl>"
tui-use snapshot

# Filter attributes
tui-use type "builtins.filterAttrs (name: value: builtins.isString) nixosConfigurations.ditto.config\n"
tui-use wait --text "nix-repl>"
tui-use snapshot

# Read Nix files
tui-use type "(builtins.readfile ../../flake.nix)\n"
tui-use wait --text "nix-repl>"
tui-use snapshot
```

### Configuration Validation

When validating configurations, use these patterns to check specific aspects:

#### Host Name and System

```bash
tui-use type "nixosConfigurations.ditto.config.networking.hostName\n"
tui-use wait --text "nix-repl>"
tui-use snapshot

tui-use type "nixosConfigurations.ditto.config.system.build.toplevel\n"
tui-use wait --text "nix-repl>"
tui-use snapshot
```

#### Service Configuration

```bash
tui-use type "nixosConfigurations.ditto.config.services.openssh.enable\n"
tui-use wait --text "nix-repl>"
tui-use snapshot

tui-use type ":t nixosConfigurations.ditto.config.services\n"
tui-use wait --text "nix-repl>"
tui-use snapshot
```

#### Package Dependencies

```bash
tui-use type "nixosConfigurations.ditto.config.system.build\n"
tui-use wait --text "nix-repl>"
tui-use snapshot

tui-use type "nixosConfigurations.ditto.config.environment.systemPackages\n"
tui-use wait --text "nix-repl>"
tui-use snapshot
```

#### Option Type Inspection

Use `:t` to check what types options resolve to:

```bash
tui-use type ":t nixosConfigurations.ditto.config.users\n"
tui-use wait --text "nix-repl>"
tui-use snapshot

tui-use type ":t nixosConfigurations.ditto.config.environment.variables\n"
tui-use wait --text "nix-repl>"
tui-use snapshot
```

### Cross-Host Comparison

Compare configurations across multiple hosts using the REPL:

```bash
# Compare host names across hosts
tui-use type "builtins.attrNames nixosConfigurations\n"
tui-use wait --text "nix-repl>"
tui-use snapshot

# Check if two hosts share the same configuration
tui-use type "nixosConfigurations.ditto.config.networking.hostName == nixosConfigurations.alakazam.config.networking.hostName\n"
tui-use wait --text "nix-repl>"
tui-use snapshot

# Inspect differences in service configuration
tui-use type "nixosConfigurations.ditto.config.services.openssh == nixosConfigurations.alakazam.config.services.openssh\n"
tui-use wait --text "nix-repl>"
tui-use snapshot

# List all hosts and their host names
tui-use type "builtins.map (host: nixosConfigurations.${host}.config.networking.hostName) (builtins.attrNames nixosConfigurations)\n"
tui-use wait --text "nix-repl>"
tui-use snapshot
```

### Expression Testing & Debugging

Test Nix expressions interactively before committing them:

```bash
# Test a simple expression
tui-use type "let x = 1 + 2; in x\n"
tui-use wait --text "nix-repl>"
tui-use snapshot

# Test a module option value
tui-use type "let cfg = { networking.hostName = \"test\"; }; in cfg\n"
tui-use wait --text "nix-repl>"
tui-use snapshot

# Debug an evaluation error by inspecting intermediate values
tui-use type "let pkgs = import <nixpkgs> {}; in pkgs\n"
tui-use wait --text "nix-repl>"
tui-use snapshot

# Test a conditional expression
tui-use type "if builtins.pathExists /etc/NIXOS then \"exists\" else \"missing\"\n"
tui-use wait --text "nix-repl>"
tui-use snapshot
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
