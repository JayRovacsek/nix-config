# NixOS Module System & Development

Distilled from the NixOS manual `development/` chapter and the pkgs-manual
`module-system` chapter. Locate sources via the discovery methods in SKILL.md —
never hardcode store paths. Condensed, not verbatim.

## Module structure

| Form | Shape |
|---|---|
| Abbreviated (most common) | `{ config, pkgs, ... }: { /* option definitions */ }`; header can be omitted entirely when neither `pkgs` nor `config` is referenced |
| Full | `{ config, pkgs, ... }: { imports = [ ... ]; options = { ... }; config = { ... }; }` |

- A module handles one logical aspect. It can *declare* options for others to
  define, and *define* options declared elsewhere (e.g. `pam.nix` declares
  `security.pam.services`, defines `environment.etc`).
- Default module set lives in `modules/module-list.nix`; those need not be re-imported.
- **Module arguments** come from three sources: built-ins (`lib`, `config`,
  `options`, `_class`, `_prefix`), `specialArgs` passed to `evalModules` (available
  while resolving `imports`), and `_module.args` (only available *after* imports
  resolve). `lib` is reserved for the Nixpkgs library — do not stuff custom
  functions into `specialArgs.lib`; add a new named attribute instead.
- Avoid relying on `_prefix`; a module must not assume its position in the config
  tree (specialisations and tests give a non-empty prefix). Use explicit options.
- `evalModules` returns `options`, `config`, `type`, `extendModules`, `_module`,
  `_type`, `class`, `graph`. `extendModules` builds on existing modules but shares
  almost no evaluation with the original — keep to one fixpoint where possible.

## Option declaration anatomy

```nix
name = mkOption {
  type = ...;          # mandatory for nixpkgs modules
  default = ...;       # omit => users MUST define it or eval errors
  defaultText = ...;   # verbatim rendering when default is complex (literalExpression/literalMD)
  example = ...;
  description = "..."; # Nixpkgs-flavoured Markdown
};
```

| Property | Behaviour |
|---|---|
| Attribute naming | camelCase, EXCEPT when referencing a Nixpkgs package — then match the package attr name (e.g. `services.nix-serve.bindAddress`) |
| `readOnly = true` | Forbids any definition other than the default |
| `internal = true` | Equivalent to `visible = false`; hides from docs |
| `visible = "shallow"` | Shows the option but not its sub-options |
| Default precedence | Option defaults have priority 1500; ordinary definitions have priority 100. Lower wins |

**Utility constructors:**

| Constructor | Result |
|---|---|
| `lib.mkEnableOption "name"` | bool, default false, example true, description "Whether to enable name." |
| `lib.mkPackageOption pkgs "name" { default = [ "attr" "path" ]; example = ...; extraDescription = ...; }` | package option; pass `null` as `default` for no default. Prefer per-module package options over nixpkgs-wide overlays (overlays slow eval and are harder to debug) |

**Extensible option types:** declare a placeholder `type = with types; nullOr
(enum [ ])` in a central module, then extend it with `mkOption { type = ... }` in
each backend module. Works only for `enum` and `submodule` (and composed forms like
`listOf (enum [...])`). Extensible declarations must use ONLY the `type` argument.
Enforces single-value constraints (e.g. one display manager) without per-backend
assertions.

## Option definitions & properties

| Constructor | Behaviour |
|---|---|
| `mkIf cond { ... }` | Pushes the conditional down into individual definitions; prevents infinite recursion when a definition depends on the value being constructed. Never use a bare `if config.x then ... else ...` at the top of `config` |
| `mkMerge [ set1 (mkIf ...) ... ]` | Merge multiple definition sets as if from separate modules |
| `mkOverride n value` | Override priority; `mkForce` = `mkOverride 50`, `mkDefault` = `mkOverride 1000`. All definitions above the lowest priority are discarded |
| `mkOrder n` | Order priority (default 1000); `mkBefore` = `mkOrder 500`, `mkAfter` = `mkOrder 1500`. Affects merge order only, not inclusion |
| `mkDefinition { file = ...; value = ...; }` | Self-contained definitions with custom position info (better error messages when copying between options). Properties like `mkForce`/`mkMerge` go INSIDE `value`, never wrapping the whole `mkDefinition`. Set `_file` at module level to apply a file location to all definitions at once |

## Option types catalogue (practical vocabulary)

Types live in `lib/types.nix` (the NixOS manual's option-types section is just a
redirect to it).

| Group | Types |
|---|---|
| Basic | `bool`, `int`, `float`, `number`, `str`, `package`, `path`, `anything` (avoid — defeats type checking), `strMatching`, `enum`, `oneOf`, `either`, `nullOr` |
| Numeric | `port` (0–65535), `positive`, `intBetween`, `numBetween` |
| Strings | `strMatching`, `strMatching'`, `nonEmptyStr`, `strMax`, `lines` (list of strings merged as newline-separated text) |
| Collections | `listOf`, `attrsOf` (strict; all attrs share type `t`; good for uniform maps), `lazyAttrsOf` (lazy; allows per-attribute definitions to differ and defers evaluation; useful for large maps like `users.users`), `nonEmptyListOf` |
| Submodules | `submodule { options = ...; }` — nested option set with its own scope; provides `name` module argument with `attrsOf`/`listOf`. `submoduleWith { modules = ...; shorthand = ...; }` is the modern form backing `evalModules`'s `type` |
| Formats | `pkgs.formats.<fmt>.type` (json, yaml, toml, ini, etc.) for `settings` options; combine with `freeformType` |
| Enum merging | Via extensible types (see above) |

## Freeform modules

- Set `freeformType` on a `submodule` to accept undeclared attributes, merged with
  the given type (commonly `attrsOf str` or a `pkgs.formats` type). Recommended ONLY
  for submodules — it nullifies name checking for the whole tree.
- Pattern: `settings = mkOption { type = submodule { freeformType =
  settingsFormat.type; options.port = mkOption { type = port; default = 8080; }; };
  default = {}; }` — arbitrary keys pass through, declared keys get type-checked,
  defaults, and manual documentation.
- Gotcha: freeform attributes cannot depend on other attributes of the same set
  without infinite recursion (`mkIf (config.settings.port == 80)` on a freeform attr
  fails). Declare those attributes as real options.

## Settings options convention (program config files)

| Format | Convention |
|---|---|
| Nix-representable (JSON/YAML/TOML/INI) | Generic `settings` option typed from `pkgs.formats.<fmt> { }`, which returns `{ type, lib?, generate }`. `generate "file.json" cfg.settings` renders to a store path — avoid for secrets |
| Non-representable | `configFile` option (path) plus optional `extraConfig` of type `lines` for arbitrary appended text |
| Defaults | Use `mkDefault` for overridable defaults; omit it for values the module requires at eval time (e.g. a `user` used to create a user account) |

## Merge / force semantics summary

- Same option defined in multiple modules: merged per type (lists concat, attrsets
  merge, submodules merge). Non-mergeable types (e.g. two non-default `int`s) cause
  a "Cannot merge definitions" conflict.
- Priority decides *whether* a definition survives; order priority decides *where*
  it lands in merged lists.

## Assertions & warnings idiom

- Put them inside `config` (usually wrapped in `mkIf`), NOT as bare Nix
  `assert`/`builtins.trace` — those give worse UX.
- `warnings = [ "..." ];` — non-fatal notices.
- `assertions = [ { assertion = !config.services.rsyslogd.enable; message =
  "rsyslogd conflicts with syslogd"; } ];` — fatal at eval, used to forbid
  incompatible combinations.

## Meta attributes

- `meta` is a top-level key like `options`/`config`. Available: `maintainers` (list
  from `lib.maintainers`), `doc` (path to a CommonMark file appended to the services
  manual), `buildDocsInSandbox` (default true).
- Each meta attribute may be defined at most once per module file.
- Sandboxed doc builds may only reference `options`, `lib`, and `pkgs.formats`;
  referencing `config` or the rest of `pkgs` breaks the build — set
  `buildDocsInSandbox = false` only when genuinely required.

## Activation scripts

- `$out/activate` runs on every boot AND every switch. Keep work out of it if
  systemd (`StateDirectory`, `CacheDirectory`) or a service `preStart` can do it.
- Define snippets via `system.activationScripts.<name>` as either a multiline string
  or `{ deps = [ "etc" ]; text = "..."; supportsDryActivation = true; }`. `deps`
  orders snippets; `supportsDryActivation` makes it run under `dry-activate`; read
  `$NIXOS_ACTION` (`dry-activate`) to branch.
- Built-in snippets: `binsh`, `etc`, `modprobe`, `specialfs`, `users`, `usrbinenv`.

## `/etc` via overlay filesystem

- `system.etc.overlay.enable = true` (experimental, kernel ≥ 6.6) replaces the perl
  activation; drops perl dependency, faster.
- `system.etc.overlay.mutable = false` mounts `/etc` read-only. Modified files are
  NOT overwritten on switch (biggest behavioural change vs perl); prior manual edits
  live in `/.rw-etc/upper`.

## What happens during a system switch

- `nixos-rebuild` → `switch-to-configuration` with action `switch`/`boot`/`test`/
  `dry-activate`. `dry-activate` prints what `test` would do.
- For `switch`/`boot`: bootloader updated first; `/nix/store` synced unless
  `NIXOS_NO_SYNC=1`.
- For `switch`/`test`: inspects `/etc/fstab` + current systemd state, computes diff,
  then runs actions in a FIXED order: stop units → run activation script → check for
  extra restarts → daemon-reexec → reset-failed → daemon-reload → user daemon-reload
  → restart `sysinit-reactivation.target` → reload → restart → start → report
  failed/newly-started units.
- Debug env vars: `STC_DISPLAY_ALL_UNITS=1` (show all units), `STC_DEBUG=1` (verbose).

## Unit handling (restart/reload logic)

- Per-unit decisions use `[Unit]`/`[Service]` `X-*` flags exposed as options:
  `reloadTriggers`, `reloadIfChanged`, `restartIfChanged`, `stopIfChanged` (default
  true). `.mount` reloads on Options-only change; `/` and `/nix` mounts reload to
  avoid crashing. `.path`/`.slice`/`.socket` ignored on change.
- `sysinit-reactivation.target` ensures early-boot units restart in correct order;
  opt in with `requiredBy`/`before = [ "sysinit-reactivation.target" ]` plus
  appropriate `restartTriggers`.
- Escape `%x`, `$FOO`, `${FOO}`, `;`, whitespace in `Exec*` directives using
  `utils.escapeSystemdExecArg`/`escapeSystemdExecArgs`.

## State revision

- `system.stateVersion` ("YY.MM") is discouraged for new module use. Prefer a
  per-module `stateRevision` (non-negative int) via
  `utils.mkStateRevisionOption { descriptionName; migrations = { "26.05" = "..."; }; }`.
- When enabled, also set
  `system.moduleStateRevisions."services.whatever.stateRevision" = cfg.stateRevision;`
  (inside the `mkIf`). Never read `config.system.stateVersion` directly.

## Nix settings as options

- `nix.settings.<name>` maps Nix config keys to typed options (e.g.
  `auto-allocate-uids`, `extra-system-features`, `experimental-features`,
  `extra-sandbox-paths`). Used by tests requiring special daemon config.

## Modular services (experimental, 25.11)

- Splits a service into a manager-agnostic core module + a framework that turns
  abstract options into systemd/launchd ones. Plug into `system.services.<name>`
  (type `attrsOf submodule`). Use `_class = "service";` and guard systemd-specific
  bits with `lib.optionalAttrs (options ? systemd)`.

## Building specific parts

- `nix-build -A config.<option>` for derivation-typed options:
  `system.build.toplevel` (or `-A system`), `system.build.etc`,
  `system.build.initialRamdisk`, `system.build.kernel`, individual units via
  `-A 'config.systemd.units."httpd.service".unit'` (quote dotted names).

## Bootspec

- Standardised bootloader data (RFC-0125), enabled by default. Extend via
  `boot.bootspec.extensions."org.example.key" = ...;` (use a unique namespace).
  External bootloaders via `boot.loader.external.installHook`.

## Non-switchable systems

- `imports = [ "${modulesPath}/profiles/image-based-appliance.nix" ]` sets
  `system.switch.enable = false`, dropping `switch-to-configuration` for
  lighter/more secure image appliances.

## NixOS test authoring essentials

| Topic | Rule |
|---|---|
| Structure | `nodes.<name>` (QEMU VMs), `containers.<name>` (systemd-nspawn), `testScript` (Python). `defaults`/`nodeDefaults`/`containerDefaults` apply options to all machines |
| Invocation | In-tree via `runTest ./x.nix` in `all-tests.nix`; out-of-tree via `pkgs.testers.runNixOSTest { name; imports; defaults; }` |
| In-tree defaults | `pkgs.*` read-only (opt out `node.pkgsReadOnly = false`), `nix.enable = false` |
| Test script | `machine.start()`, `start_all()`, `machine.wait_for_unit`, `machine.succeed`, `machine.wait_until_succeeds`; `t` exposes `unittest.TestCase` assertions; `@polling_condition` fails early |
| Lint | `skipLint`/`skipTypeCheck` for dev cycles (don't commit); scripts are Pyflakes-linted and Mypy-checked by default |
| Requirements | VMs need `kvm` system feature; nspawn containers need `auto-allocate-uids`, `cgroups`, `uid-range` feature, and `extra-sandbox-paths = [ "/dev/net" ]` when sharing a VLAN with VMs |
| Interactive | `nix-build -A nixosTests.login.driverInteractive` then `./result/bin/nixos-test-driver`; `test_script()` runs the whole script; `interactive.sshBackdoor.enable` / `enableDebugHook` for debugging; `--keep-machine-state` reuses VM state |
| Overrides | `extendNixOS { module; specialArgs; }`, `extend { modules; specialArgs; }`, `overrideTestDerivation` |

### Sandbox patterns for service tests

| Pattern | Rule |
|---|---|
| Minimal imports | Build test nodes from the modules under test (e.g. `self.nixosModules.nginx`), never a full host config — hosts carry hardware, disko, and secrets baggage |
| Mock agenix secrets | Tests run sandboxed and cannot reach real secrets: declare `options.age.secrets` as `lib.mkOption { type = lib.types.attrsOf lib.types.anything; default = { }; }` and point entries at `pkgs.writeText` dummies |
| Network/DNS isolation | Tests run offline or in a closed network: map domains to loopback (`networking.hosts."127.0.0.1" = [ "service.test.local" ];`) and set `enableACME = false; forceSSL = false;` (or use snakeoil certs) to test ingress flows |
| Python testScript API | `machine.wait_for_unit("x.service")` blocks until the unit is active; `machine.wait_for_open_port(80)` until TCP listens; `machine.succeed`/`machine.fail` run commands with the expected exit status; use `curl -v -L` to see headers in logs |

## Guidelines (authoring in a real config repo)

| Guideline | Rationale |
|---|---|
| Keep modules single-purpose; split declarations/definitions cleanly; prefer `mkIf`/`mkMerge` over nested `if` | Predictable evaluation |
| Give `enable` options via `mkEnableOption`; give package options via `mkPackageOption` instead of hardcoding `pkgs.foo` | Less boilerplate, consistent docs |
| Never write a bare `if config.x` at the top of `config` | Wrap in `mkIf` to avoid infinite recursion |
| Use `mkDefault` for overridable defaults, plain values for required ones; reserve `mkForce` for genuine overrides | Priority hygiene |
| Prefer `lazyAttrsOf` for large per-key maps; `attrsOf` for uniform maps | Evaluation cost |
| Scope `freeformType` to submodules only; declare any attribute that needs to reference siblings | Name checking, recursion |
| Escape all `Exec*` argument content with `utils.escapeSystemdExecArgs` | systemd parsing |
| Don't rely on `_prefix`; don't put custom helpers in `specialArgs.lib` | Position independence |
| Add `meta.maintainers` where the repo convention expects it; keep each meta attribute to one definition per file | Conventions |
| Prefer `stateRevision` over `system.stateVersion` for new modules | Modern idiom |
| Validate module changes with a `nixos-test` and/or `nix flake check`; build only the relevant part (`-A config.…`) while iterating | Fast feedback |
| Verify option types against local docs (`lib/types.nix`) before inventing one; prefer `port`, `nonEmptyStr`, `enum`, `submodule` over `anything` | Type safety |
| Write assertions/warnings for incompatible option combinations or deprecated fields | Better than silent breakage |
| Australian English in comments/descriptions per repo policy | Repo convention |
