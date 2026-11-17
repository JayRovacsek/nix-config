# Lix CLI — Command Reference & Settings

Offline reference for driving the `nix` CLI (Lix 2.96.x) without web access,
distilled from the locally-installed Lix man pages, the mdBook HTML manual, and the
bundled flake registry. No store paths are hardcoded — re-locate every source at
runtime via the discovery methods in SKILL.md. Condensed, not verbatim.

## Two CLI generations

| Generation | Commands | Notes |
|---|---|---|
| New CLI (`nix <command>`, internally `nix3-*`) | `build`, `eval`, `flake`, `develop`, `shell`, `run`, `store`, `profile`, … | Requires the `nix-command` experimental feature. Every subcommand's man page carries a "this program is experimental" warning. **Preferred** |
| Legacy CLI | `nix-build`, `nix-env`, `nix-store`, `nix-shell`, `nix-instantiate`, `nix-collect-garbage`, `nix-copy-closure`, `nix-hash`, `nix-channel`, … | Separate top-level binaries, still shipped and documented (own `man1` pages). Fall back only when a capability has no new-CLI equivalent |

Both share a common option set (see *Common options* below).

## Command groups (new CLI)

| Group | Members |
|---|---|
| Installables-based | `build`, `eval`, `develop`, `shell`, `run`, `search`, `path-info`, `why-depends`, `log`, `repl` — accept *installables* and the shared "Common evaluation options" + "Common flake-related options" blocks |
| `nix flake` | `archive`, `check`, `clone`, `info`, `init`, `lock`, `metadata`, `new`, `prefetch`, `show`, `update` |
| `nix store` | `add-file`, `add-path`, `cat`, `copy-log`, `copy-sigs`, `delete`, `diff-closures`, `dump-path`, `gc`, `ls`, `make-content-addressed`, `optimise`, `path-from-hash-part`, `ping`, `prefetch-file`, `repair`, `sign`, `verify` |
| `nix profile` | `diff-closures`, `history`, `install`, `list`, `remove`, `rollback`, `upgrade`, `wipe-history`. Replaces `nix-env`; default profile lives under `$XDG_STATE_HOME/nix/profile` (or `$NIX_STATE_DIR/...` for root) when `use-xdg-base-directories = true` |
| Other | `config` (+ `config show`), `copy`, `daemon`, `derivation` (`add`, `show`), `doctor`, `edit`, `fmt`, `hash` (`file`, `path`, `to-base16/32/64/sri`), `key` (`generate-secret`, `convert-secret-to-public`), `nar` (`cat`, `dump-path`, `ls`), `help`, `help-stores`, `print-dev-env`, `registry` (`add`, `list`, `pin`, `remove`), `upgrade-nix` |

## Most useful commands + key flags

| Command | Key flags |
|---|---|
| `nix build` | `--print-out-paths`, `--no-link`, `--out-link`/`-o <path>`, `--profile <path>`, `--dry-run`, `--json`, `--rebuild`, `--stdin`. Creates `./result*` symlinks unless `--no-link` |
| `nix eval` | `--json`, `--raw` (strings without quotes), `--apply <expr>` (maps a function over each result), `--read-only`, `--impure` |
| `nix develop` | Dev shell from `devShells.<system>.default` (falls back to `packages.<system>.default`). `--build`, `--check`, `--profile`, `--command`/`-c`. Honours `bash-prompt`, `bash-prompt-prefix`, `bash-prompt-suffix` and `nixConfig` from the flake |
| `nix shell` | Shell with packages on `$PATH`. `--command`/`-c`, `--ignore-environment`/`-i`, `--keep`/`-k`, `--unset`/`-u`, `--stdin` |
| `nix run` | Resolves `apps.<system>.default` then `packages.<system>.default`, using `meta.mainProgram` or `<out>/bin/<name>` |
| `nix search` | Searches `packages.<system>`/`legacyPackages.<system>` (respects `recurseForDerivations`). `--exclude`/`-e`, `--json`. Matches `meta.description`; patterns are regexes (`^`, `.*`) |
| `nix path-info` | `--all`, `--closure-size`/`-S`, `--size`/`-s`, `--human-readable`/`-h`, `--sigs`, `--json`, `--stdin` |
| `nix why-depends` | `--derivation`, `--all`/`-a`, `--precise` |
| `nix log` | Fetch a build log for a store path from `/nix/var/log/nix/drvs` or a substituter's `<cache>/log/<base-name>` |
| `nix repl` | `:l <filename>`, `:r`; honours `repl-overlays`; `--stdin` |
| `nix flake update` | `--commit-lock-file`, `--update-input`. Shared flake flags: `--override-input <path> <url>` (implies `--no-write-lock-file`), `--no-write-lock-file`, `--no-update-lock-file`, `--reference-lock-file`, `--output-lock-file`, `--inputs-from`, `--override-flake` |

## Common options (shared across most commands)

| Group | Options |
|---|---|
| Verbosity | `--verbose`/`-v` (repeatable, levels 0 errors-only … 5 vomit), `--quiet`, `--debug`, `--log-format <fmt>` (`raw`, `internal-json`, `bar`, `bar-with-logs`, `multiline`, `multiline-with-logs`), `--print-build-logs`/`-L` |
| Build control | `--max-jobs`/`-j <n>` (`auto` = CPU count, `0` = no local builds), `--cores`, `--max-silent-time`, `--timeout`, `--keep-going`/`-k`, `--keep-failed`/`-K`, `--fallback`, `--no-build-output`/`-Q` |
| Evaluation | `--arg <name> <expr>`, `--argstr <name> <string>`, `--attr`/`-A <attrPath>`, `--expr`/`-E`, `--include`/`-I <path>`, `--impure`, `--eval-store <store-url>`, `--debugger`. `--arg` supports dotted attribute paths (`--arg config.allowUnfree true`) but rejects merging two `--arg` forms for the same key |
| Global | `--offline`, `--refresh`, `--repair`, `--option <name> <value>` (overrides `nix.conf`), `--help`, `--version` |

Every `nix.conf` setting also has a `--<name>` command-line flag (e.g.
`--max-jobs 16`), per the nix.conf "Command line flags" section.

## nix.conf settings that matter (exact names)

From the `nix.conf.5` "Available settings" catalogue, grouped by concern:

| Concern | Settings |
|---|---|
| Features | `experimental-features`, `extra-experimental-features`, `deprecated-features` |
| Parallelism / jobs | `max-jobs`, `cores`, `extra-local-jobs`, `max-substitution-jobs`, `max-silent-time`, `timeout`, `build-poll-interval` |
| Keep / GC | `keep-derivations`, `keep-env-derivations`, `keep-outputs`, `keep-build-log`, `keep-going`, `keep-failed`, `gc-reserved-space`, `min-free`, `max-free`, `min-free-check-interval`, `auto-optimise-store` |
| Substitution | `substituters`, `trusted-substituters`, `trusted-public-keys`, `require-sigs`, `always-allow-substitutes`, `builders-use-substitutes`, `narinfo-cache-negative-ttl`, `narinfo-cache-positive-ttl`, `hashed-mirrors` |
| Trust / security | `trusted-users`, `allowed-users`, `allowed-uris`, `access-tokens`, `restrict-eval`, `sandbox`, `sandbox-paths`, `extra-sandbox-paths`, `sandbox-build-dir`, `sandbox-dev-shm-size`, `sandbox-fallback`, `require-drop-supplementary-groups`, `auto-allocate-uids`, `start-id`, `build-users-group`, `secret-key-files`, `ssl-cert-file` |
| Builders | `builders`, `build-hook`, `pre-build-hook`, `post-build-hook`, `diff-hook`, `run-diff-hook` |
| Flakes | `flakes` (via experimental-features), `accept-flake-config`, `flake-registry`, `use-registries`, `commit-lockfile-summary`, `allow-dirty`, `warn-dirty`, `allow-import-from-derivation`, `warn-import-from-derivation` |
| Networking | `http-connections`, `http2`, `http3`, `download-attempts`, `download-speed`, `stalled-download-timeout`, `initial-connect-timeout`, `max-connect-timeout`, `netrc-file`, `tarball-ttl` |
| Eval / system | `eval-cache`, `eval-system`, `system`, `system-features`, `extra-platforms`, `pure-eval`, `nix-path`, `max-call-depth`, `allow-symlinked-store`, `allow-unsafe-native-code-during-evaluation`, `allowed-impure-host-deps` |
| Misc | `log-format`, `log-lines`, `max-build-log-size`, `compress-build-log`, `use-xdg-base-directories`, `use-sqlite-wal`, `use-cgroups`, `plugin-files`, `repl-overlays`, `temp-dir`, `build-dir`, `preallocate-contents`, `print-missing`, `fsync-metadata`, `sync-before-registering`, `user-agent-suffix`, `nar-buffer-size`, `id-count` |
| Lix-specific | `extra-local-jobs`, `extra-sandbox-paths`, `builtin-builder-sandbox-paths`, `darwin-log-sandbox-violations`, `debugger-on-trace`, `debugger-on-warn`, `abort-on-warn`, `pasta-path`, `use-case-hack`, `use-cgroups`, `rpc-sockets`, `build-dir`/`sandbox-build-dir` |

## Experimental features catalogue (Lix)

`experimental-features` / `extra-experimental-features` accept:

| Feature | Effect |
|---|---|
| `nix-command` | Enables the new CLI |
| `flakes` | Flakes support |
| `auto-allocate-uids` | Allocate UIDs/GIDs dynamically in builds |
| `cgroups` | Run builds inside cgroups |
| `coerce-integers` | Coerce integers to strings in interpolation |
| `flake-self-attrs` | Define flake input attrs for `self` (ported upstream) |
| `lix-custom-sub-commands` | `lix foo` invokes a `lix-foo` binary |
| `pipe-operator` | Pipe arguments through a chain of functions (like `lib.pipe`) |
| `read-only-local-store` | `read-only` parameter in local store URIs |
| `repl-automation` | REPL without a line editor; prints ENQ when ready |
| `rpc-sockets` | Exposes the `lix-xp-1` daemon protocol to clients |

`deprecated-features` (Lix compatibility shims for legacy parser behaviour):
`ancient-let`, `broken-string-escape`, `broken-string-indentation`,
`cr-line-endings`, `floating-without-zero`, `floor-ceil-corrupt-integers`,
`nix-path-shadow`, `nul-bytes`, `or-as-identifier`, `rec-set-dynamic-attrs`,
`rec-set-merges`, `rec-set-overrides`, `shadow-internal-symbols`,
`tokens-no-whitespace`, `url-literals`.

## Store types (`nix help-stores`)

Store URL schemes / types: `local`, `local-daemon`, `local-binary-cache`,
`http-binary-cache`, `s3-binary-cache`, `ssh`, `experimental-ssh`, `dummy`.
`--store <url>` and `--eval-store <url>` select these. `dummy` is useful for
eval-only work; `read-only-local-store` adds a `read-only` param to `local`.

## Lix vs CppNix (visible in the docs)

| Difference | Detail |
|---|---|
| Manual title | "Lix Reference Manual"; edit links point to `git.lix.systems/lix-project/lix` (not github.com/NixOS/nix) |
| Lix-only experimental features | `lix-custom-sub-commands`, `pipe-operator`, `read-only-local-store`, `repl-automation`, `rpc-sockets`, `coerce-integers`, `flake-self-attrs` |
| Lix-only settings | `extra-local-jobs`, `builtin-builder-sandbox-paths`, `darwin-log-sandbox-violations`, `debugger-on-trace`, `debugger-on-warn`, `abort-on-warn`, `pasta-path`, `use-case-hack`, `rpc-sockets` |
| `deprecated-features` | A Lix mechanism for toggling legacy parser quirks |
| `pasta` | A Lix sandbox tool with its own advanced-topics page and `pasta-path` setting |
| Binaries | The binary is `nix` but `lix` is also available; `lix-custom-sub-commands` lets `lix <name>` dispatch to `lix-<name>` |

## Guidelines

| Guideline | Rationale |
|---|---|
| Prefer the new CLI (`nix build`, `nix flake …`) over legacy (`nix-build`, `nix-env`) | New CLI is the maintained interface; legacy binaries remain for compatibility |
| `nix-command` must be enabled (via `experimental-features` or `--extra-experimental-features nix-command`) for any `nix3-*` subcommand | Otherwise the new CLI errors |
| Man pages are gzip-compressed: use `gzip -dc <file>.gz` | A bare `gzip -c` re-compresses and yields binary; some `zcat` wrappers point at an unusable `gzip` — fall back to a working `gzip -dc` from another store path |
| Decompressed roff has null bytes | The read tool rejects it as binary; pipe through `rg -a` |
| mdBook HTML has heavy chrome (~180 lines before `<main>`) | Extract the content section or grep for `<code>`/`<h1 id=...>` rather than reading whole files |
| `--argstr` for plain strings (no escaping); `--arg` for Nix expressions | Dotted paths work but two `--arg` forms for the same base key are rejected |
| `--impure` is required for `<nixpkgs>`-style search paths or `--file -` | Reading from stdin implies `--impure` |
| Store URLs for `--store`/`--eval-store` come from `nix help-stores` | `dummy` store is handy for eval-only checks without touching the real store |
| Don't hardcode store paths | Re-derive via the discovery methods in SKILL.md; they change on every nixpkgs update |
| Verify a flag exists before using it | Grep the relevant `nix3-<cmd>.html` (or `nix3-<cmd>.1.gz`) for `--flag` to confirm spelling and that the option is real |
| For a whole-manual sweep, grep `print.html` | It concatenates the entire manual into one file — faster than iterating per-page |
| Cores/jobs tuning model | max consumed cores = `max-jobs` × `NIX_BUILD_CORES`; `cores = 0` means "use all cores"; `max-jobs = 0` disables local builds (still substitutes/remotes) |
