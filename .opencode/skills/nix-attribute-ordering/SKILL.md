---
name: nix-attribute-ordering
description: Reorder and tidy Nix configuration files (NixOS hosts, modules, flake parts) into a consistent lexicographic attribute layout with expanded root attrsets, then prove via evaluation that nothing changed semantically. Use whenever the user asks to sort, tidy, align, normalise, or "make consistent" any .nix file, restructure a host config to match another host's layout, or apply the repo's attribute ordering conventions — even if they don't say the word "sorted".
---

# Nix attribute ordering

Apply a single predictable layout to any `.nix` configuration file, and prove
the result is semantically identical by comparing evaluation outputs before
and after. The layout exists so reviewers can scan any host or module and
find options in the same place every time; the evaluation gate exists because
reordering attrsets is safe but reordering *lists* is not, and the difference
must never be left to chance.

## The layout rules

Within every attrset (including the top-level module body), order attributes
as follows:

1. **`inherit` lines first.** Structural preamble stays at the top, e.g.
   `inherit (user-configs) users home-manager;`. The `imports` list also
   stays in this preamble, immediately after the `inherit` lines — do not
   sort it down into the option block.
2. **`enable*` options first** within their own attrset. Any option whose name
   begins with `enable` (e.g. `enable`, `enableConfig`,
   `enableRedistributableFirmware`) precedes all non-`enable` siblings.
3. **Everything else lexicographically** (ASCII order, case-sensitive:
   uppercase before lowercase, so `HSA_...` precedes `LD_...`).

Additional structural rules:

- **Expand shared roots, collapse singletons.** Expansion exists to group
  siblings: when a root has two or more leaves, write them in one attrset
  literal; when it has a single leaf, keep the dotted form — wrapping a lone
  option in `name = { leaf = ...; };` adds a level without grouping anything.

  ```nix
  # two siblings -> expand
  boot = {
    kernelModules = [ "amdgpu" ];
    supportedFilesystems = [ "ntfs" ];
  };

  # lone leaves -> stay dotted
  age.identityPaths = [ "/agenix/id-ed25519-${config.networking.hostName}-primary" ];
  security.rtkit.enable = true;
  ```

  The same test applies at every depth: `loader.systemd-boot.enable` stays
  dotted inside `boot` while it is the only `loader.*` entry; two `loader.*`
  entries must be expanded.
- **Drop no-op values.** An assignment that cannot change the evaluated
  config is noise: an empty additive list (`extraModulePackages = [ ];`) is
  identical to omitting it, because Nix merges list option definitions
  additively and the option default is already `[ ]`. Remove such assignments
  rather than sorting them. (Only when the option's default really is the
  empty list — a deliberate `mkForce [ ]` to discard inherited values is a
  meaningful assignment and stays.)
- **One blank line between distinct root options.** Comments stay glued to
  the option they describe (the comment moves with the option when it sorts).
- **Sort nested attrsets recursively** — the same rules apply at every depth
  (e.g. inside `disko.devices.disk.main.content`).

## What must NOT be reordered

- **List elements.** `environment.systemPackages`, `boot.kernelModules`,
  `imports` entries, and any other list are *values*; their order can feed
  into derivation hashes (buildEnv paths, kernel module load order). Sort
  attrset **keys**, never list contents, unless the user explicitly asks.
- **`let` bindings** — leave their order alone unless asked.
- **Comments** — never drop or reposition a comment away from its option.

## Validation workflow (mandatory)

Reordering attrsets must be a no-op for the evaluated system. Prove it:

1. **Before editing**, capture the baseline outpath for the affected system:

   ```sh
   nix eval --extra-experimental-features 'nix-command flakes' \
     .#nixosConfigurations.<host>.config.system.build.toplevel.outPath
   ```

   For files not reachable via `nixosConfigurations` (modules, flake parts),
   fall back to `nix-instantiate --parse <file>` plus whichever eval target
   consumes them.
2. **Apply the reordering**, then format: `nixfmt <files>`.
3. **Re-evaluate** with the same command. The outpath **must be byte-identical**
   to the baseline. If it differs, the change was not a pure reorder — diff
   option values (`config.boot.kernelParams`, `config.fileSystems`,
   `config.environment.variables`, …) to find what leaked in, and fix it
   before staging.
4. Stage or commit only after the outpaths match.

If the user has *also* requested semantic changes (dedupe, module extraction,
disko migration), capture the baseline *after* those changes land, so the
pure-reorder gate stays exact; semantic deltas are then explained separately
by diffing individual options.

## Worked example

Before:

```nix
  age = {
    identityPaths = [ "/agenix/id-ed25519-${config.networking.hostName}-primary" ];
  };
  boot.extraModulePackages = [ ];
  programs.fuse.userAllowOther = true;
  programs.ssh.publicHostKeyBase64 = "...";
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
```

After:

```nix
  age.identityPaths = [ "/agenix/id-ed25519-${config.networking.hostName}-primary" ];

  programs = {
    fuse.userAllowOther = true;
    ssh.publicHostKeyBase64 = "...";
  };

  services = {
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };
```

Note: the single-leaf `age` wrapper collapses to a dotted path, the no-op
`extraModulePackages = [ ];` disappears entirely, the two-sibling `programs`
root expands, `enable` leads inside `pipewire`, `alsa` sorts before `pulse`,
and distinct roots are separated by a blank line.
