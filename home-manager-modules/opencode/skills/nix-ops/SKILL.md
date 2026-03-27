# Nix Operations Skill

Use this skill when you need to build, test, lint, or format code in this Nix configuration repository.

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

1.  **Read:** Use `nix search` or read `flake.nix` to understand inputs and outputs.
2.  **Edit:** Modify `.nix` files.
3.  **Format:** Run `nix fmt`.
4.  **Verify:** Run `statix check` and `deadnix`.
5.  **Build:** Verify the build succeeds before asking the user to apply/switch.
