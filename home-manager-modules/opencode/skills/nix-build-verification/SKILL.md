---
name: nix-build-verification
version: "1.0.0"
description: Covers build verification, linting, and testing patterns for Nix code (.nix files). Includes running nix flake check, reading skill instructions for build/test/lint commands, and preserving user data and critical configurations.
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
---

# Nix Build Verification Skill

This skill covers the verification steps that MUST be completed before considering any Nix configuration change as finished. Follow these patterns to ensure builds succeed and user data is preserved.

## Mandatory Verification Steps

Before considering work complete, you MUST:

1. Run `nix flake check` or the appropriate build command for the repository.
2. Read the relevant skill instructions (e.g. `nix-ops`) for build/test/lint commands specific to the repository.
3. Do not remove user data or critical configurations without explicit instruction.

## Build Commands

### Full Verification (Recommended)

```bash
# Run all configured checks including formatting, linting, and package builds
nix flake check
```

### Selective Builds

```bash
# Build a specific host configuration
nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel

# Build a specific package
nix build .#<package_name>

# Dry run without switching
nixos-rebuild build --flake .#<host>
```

## Verification Checklist

| Step      | Command           | Purpose                    |
| --------- | ----------------- | -------------------------- |
| Format    | `nix fmt`         | Auto-format all .nix files |
| Lint      | `statix check .`  | Check for anti-patterns    |
| Dead code | `deadnix .`       | Find unused definitions    |
| Typos     | `typos`           | Spell check                |
| Build     | `nix flake check` | Full build and test suite  |

## Preserving User Data

When making changes:

- **Never** remove or modify user configurations without explicit user instruction
- **Never** delete secrets, credentials, or sensitive data
- **Always** verify that existing configurations remain intact after changes
- If a change might affect user data, STOP and confirm with the user before proceeding

## Error Handling

If verification fails:

1. Identify the root cause from the error output
2. Fix the underlying issue
3. Re-run the full verification suite
4. Do not claim completion until all checks pass
