---
name: nix-tooling-workflow
version: "1.0.0"
description: Covers tool discovery, package validation, and execution patterns for Nix-based development workflows. Includes preferring local tools from direnv, falling back to nix run/nix shell, discovering packages via nixos MCP server, and formatting with nixfmt.
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - WebFetch
---

# Nix Tooling Workflow Skill

This skill defines the tool discovery and execution strategy for working within this Nix configuration repository. Follow these patterns to ensure reproducible, consistent tool usage.

## Tool Discovery Priority

Always follow this priority order when needing a tool:

### 1. Prefer locally available tools

OpenCode commonly runs inside a `direnv` shell (or similar environment) that already provides required binaries on `$PATH`. If a tool is available locally, use it directly rather than wrapping it in a Nix command.

```bash
# Check if tool is available
which <tool>

# Use directly if found
<tool> <arguments>
```

### 2. Fallback to Nix

If a required tool is not on `$PATH`, use Nix to obtain it:

```bash
# Run a tool via nix
nix run nixpkgs#<package> -- <arguments>

# Enter a shell with a tool
nix shell nixpkgs#<package> -c <command>
```

### 3. Package Discovery & Validation

When you need a tool that isn't locally available and you're unsure of the Nix package name:

1. **First attempt:** Search for the required package using the `nixos` MCP server.

   ```bash
   nixos search --query <package-name>
   ```

2. **Fallback:** Use web search to find packages described in the official `nixpkgs` repository.

3. **If a tool is required that is not already defined in `nixpkgs`:** STOP and ask the user for clarification or pathways forward.

## Formatting

Always format Nix files before committing:

```bash
# Format all .nix files using nixfmt (80 character width)
nix fmt

# Format a single file
nixfmt <file.nix>
```

## Package Discovery Examples

```bash
# Search for a package
nixos search --query deadnix

# Get package details
nixos info --query deadnix

# Browse options for a package
nixos browse --query <package-prefix>
```

## When to Ask for Help

STOP and ask the user if:

- A required tool is not found in `nixpkgs` via search
- The tool you need is not available locally and you cannot determine the correct Nix package name
- You suspect the tool may have complex dependencies that require user guidance
