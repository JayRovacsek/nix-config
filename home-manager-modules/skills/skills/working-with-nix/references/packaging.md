# nixpkgs Packaging, Overlays & Stdenv

Distilled from the local pkgs manual (`doc/using`, `doc/functions`,
`doc/build-helpers`, `doc/stdenv`, `doc/packages`, `doc/languages-frameworks`,
`styleguide.md`, `function-catalog.json`). Locate sources via the discovery methods
in SKILL.md — never hardcode store paths. Condensed, not verbatim.

## nixpkgs configuration (`nix.conf`-style `config`)

| Topic | Rule |
|---|---|
| Resolution order | `$NIXPKGS_CONFIG` → `~/.config/nixpkgs/config.nix` → `~/.nixpkgs/config.nix` (legacy) → empty. On NixOS, `NIXPKGS_CONFIG` points to `/etc/nix/nixpkgs-config.nix` (system-wide, not auto-created). The `nixpkgs.config` NixOS option does NOT affect `nix-env`/`nix-shell` |
| Flakes | Ignore this lookup entirely — pass `config` directly when importing nixpkgs. The lookup only applies to channels / `<nixpkgs>` |

**Key config keys (exact names):**

| Key | Behaviour |
|---|---|
| `allowUnfree = true;` | Allow all unfree. For one invocation use env `NIXPKGS_ALLOW_UNFREE=1` |
| `allowUnfreePackages = [ "vscode" ... ];` | Allowlist by name. In NixOS modules these lists merge additively across modules |
| `allowUnfreePredicate = pkg: ...;` | Programmatic predicate (combine with the list; either matching one is enough) |
| `allowlistedLicenses` / `blocklistedLicenses` | `with lib.licenses; [ ... ]`. `allowlistedLicenses` only applies to unfree unless `allowUnfree` is set; `blocklistedLicenses` applies to all licenses |
| `allowBroken = true;` | Allow broken packages (or env `NIXPKGS_ALLOW_BROKEN=1`) |
| `allowUnsupportedSystem = true;` | Or env `NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1` |
| `permittedInsecurePackages = [ "hello-1.2.3" ];` | Or env `NIXPKGS_ALLOW_INSECURE=1`. Only checked if `allowInsecurePredicate` is absent |
| `allowInsecurePredicate = pkg: ...;` | Custom insecure-package policy |
| `problems.handlers.<pkg>.<kind> = "warn" \| "ignore" \| "error";` and `problems.matchers = [ { kind = "removal"; handler = "warn"; } ];` | Modern problem-handling. Default matcher warns on `removal`. Problem kinds: `removal`, `deprecated`, `maintainerless` (auto when `meta.maintainers == []`), `broken` (auto when `meta.broken = true`). Package names come from `lib.getName` (prefers `pname`, falls back to extracting from `name`) |
| `packageOverrides = pkgs: { ... };` | Legacy single-arg override; equivalent to an overlay with only `prev`. Prefer real overlays |

**buildEnv idiom** for declarative user environments: `paths`, `pathsToLink`
(`/bin`, `/share` are good defaults; add `/Applications` on macOS),
`extraOutputsToInstall` (`man`, `doc`, `info`), `postBuild` (e.g. `install-info`).

## Overlays

| Topic | Rule |
|---|---|
| Definition | A function of two args returning a package set. Modern naming `final: prev:`, older `self: super:` |
| **Rule** | Use `final` for the *dependencies* of packages you define in the overlay; use `prev` for the *original recipe* you are overriding and for library functions like `callPackage`. `prev` lacks anything added by the current or later overlays |
| Ordering | Overlays are applied in order; order matters when several override the same attr |
| Recomputation | `pkgs.extend` / `pkgs.appendOverlays` recompute the fixpoint (expensive) — avoid; pass `overlays = [ ... ]` as an argument instead |
| Lookup order (when not passed as an argument) | `overlays` arg → `<nixpkgs-overlays>` → `~/.config/nixpkgs/overlays.nix` or `~/.config/nixpkgs/overlays/` (error if both). Directory contents are ordered lexicographically |
| `lib.overrideExisting` | A `lib.customisation` helper — override a package *only if it already exists*, so you don't accidentally introduce a new top-level attr when the package was removed/renamed. Idiom: `lib.overrideExisting "foo" (final: prev: { foo = prev.foo.override { ... }; })` |
| Alternative-switching | `blas`/`lapack` via `blasProvider`/`lapackProvider`; `mpi = final.mpich;`. Guard ILP64 with `assert (!blas.isILP64) && (!lapack.isILP64);` |

## Overrides (single-package)

| Form | Behaviour |
|---|---|
| `<pkg>.override { arg = val; }` | Change the *function arguments* passed to the package's builder function. Also supports `override (prev: { ... })` to access prior args. Use for changing build options / dependency choices |
| `<pkg>.overrideAttrs (finalAttrs: previousAttrs: { ... })` | Override the attrset passed to `stdenv.mkDerivation`. **Preferred in almost all cases.** Use the names you wrote in the source (`buildInputs`, not the generated form). `finalAttrs` = final attrs + `finalPackage`; `previousAttrs` = original attrs. A single-arg function means `previousAttrs`; args can be omitted entirely (`{ separateDebugInfo = true; }`) |
| `<pkg>.overrideDerivation (old: { ... })` | Overrides the *final* derivation attrs. **Avoid in nixpkgs**: it evaluates the derivation first (breaks abstraction, perf cost), and things like `separateDebugInfo` won't work because they're processed by `mkDerivation`, not the raw derivation. For ad-hoc use only |
| `lib.makeOverridable f args` | Makes a function's result `.override`-able |

## Platform support

| Tier | Platforms | Notes |
|---|---|---|
| 1 | `x86_64-linux` | Problems block updates, full CI/security |
| 2 | `aarch64-linux`, `aarch64-darwin` | Functional, Hydra+ofBorg, but darwin has no cross-compiling |
| 3 | musl, i686, riscv64, freebsd, etc. | Updates may break, limited/no Hydra |
| 4–7 | minimal to none | — |

- Use `meta.platforms = lib.platforms.linux` (or `lib.platforms.all`) and
  `meta.badPlatforms` to exclude known-bad ones (e.g.
  `[ lib.systems.inspect.platformPatterns.isStatic ]` for dynamic-link-only packages).
- `lib.meta.availableOn platform pkg` tests buildability; used to auto-disable
  optional deps (e.g. systemd support) when unavailable.

## Key `lib` functions & generators

| Function / namespace | Purpose |
|---|---|
| `lib.getName`, `lib.getVersion`, `lib.getBin pkg` | Name/version extraction |
| `lib.getExe pkg` | `= ${pkg}/bin/${meta.mainProgram or pname}`; `lib.getExe' pkg "name"` for other executables |
| `lib.makeBinPath`, `lib.makeSearchPath`, `lib.makeSearchPathOutput "debug" "lib/debug"` | Path composition |
| `lib.fakeHash` / `lib.fakeSha256` / `lib.fakeSha512` | Hash discovery |
| `lib.optionals`, `lib.lists`, `lib.attrsets`, `lib.strings`, `lib.licenses`, `lib.maintainers`, `lib.teams`, `lib.sourceTypes`, `lib.platforms` | Standard namespaces |
| Generators (`generators.toINI`/`toJSON`/`toYAML`) | Call interface `generatorName configFunctions data`. Override `mkKeyValue`/`mkValueString`/`mkSectionName` to tune output. Use `mkKeyValueDefault { mkValueString = ...; } ":"` |
| `lib.fetchers.proxyImpureEnvVars` | Reuse for fetchers that honour proxy env vars |
| `lib.customisation.extendMkDerivation { constructDrv; extendDrvArgs; excludeDrvArgNames; transformDrv; }` | Build a new fixed-point-aware build helper on top of an existing one |
| `function-catalog.json` | Lists every documented `lib.*` namespace, its source file (e.g. `lib.strings` → `lib/strings.nix`), and group; useful for locating a function's definition offline |

## Fetchers (build-helpers)

| Fetcher | Notes |
|---|---|
| General | Nixpkgs fetchers are **fixed-output derivations** (download at *build* time, use substituters, only re-download when hash changes). Built-in `builtins.fetch*` download at *eval* time and are **not allowed in nixpkgs** |
| Hash rule | The `hash` refers to the *derivation output*, not the raw download. **Always update the hash when you change any fetcher param** (url, stripRoot, etc.). Use the fake-hash method (`""` / `lib.fakeHash`) and read `got:` from the error. Use only the listed fake hashes (else `curl --insecure` is used → MITM risk) |
| `fetchurl` | `url` XOR `urls`; `hash` preferred over `sha256`/`outputHash`. Supports `executable`, `downloadToTemp` + `postFetch` (use `$downloadedFile`), `netrcPhase` + `netrcImpureEnvVars` (secrets via env, not inline), `curlOpts`/`curlOptsList`, `showURLs`. `preferLocalBuild` defaults true |
| `fetchzip` | Downloads + decompresses (not just .zip; handles tar formats). `stripRoot` defaults true; `extension`, `recursiveHash` defaults true, `downloadToTemp` defaults true. Add `unrar` to `nativeBuildInputs` for .rar |
| `fetchgit` | `url` + `rev` or `tag` (prefer `tag` over `rev = version` for safety) + `hash`. Options: `fetchSubmodules`, `fetchLFS`, `leaveDotGit`, `deepClone`, `fetchTags`, `sparseCheckout`, `rootDir` |
| `fetchFromGitHub` | `owner`, `repo`, `rev`/`tag`, `hash`. Uses `fetchzip` by default; auto-switches to `fetchgit` if `fetchSubmodules`/`fetchLFS`/`deepClone`/`leaveDotGit`/`forceFetchGit` set, or `sparseCheckout`/`rootDir` non-empty. `githubBase` for other instances |
| Analogous helpers | `fetchFromGitLab` (`domain`), `fetchFromBitbucket`, `fetchFromGitea`/`fetchFromForgejo`/`fetchFromCodeberg`, `fetchFromSourcehut` (remember the `~`), `fetchFromRadicle`, `fetchFromHuggingFace` (set `backend = "lfs"`), `fetchFromRepoOrCz`, `fetchFromGitiles`, `fetchFromTangled` |
| `fetchpatch` | Like `fetchurl` but normalises patches (strips VCS noise). Options `relative`, `stripLen`, `excludes`, `includes`, `hunks`, `revert`. Changing these requires changing `hash`. `fetchDebianPatch` wraps it for Debian archives |
| `requireFile` | For non-redistributable files the user must supply manually (`nix-store --add-fixed`). Only for unfree, non-redistributable software |

## stdenv / mkDerivation anatomy

| Topic | Rule |
|---|---|
| Naming | Prefer `pname` + `version` over `name` (RFC 0035) so version can be reused; **use the fixed-point form** `mkDerivation (finalAttrs: { pname; version; src = ... "${finalAttrs.version}"; })` instead of `rec` — `rec` self-references ignore later `overrideAttrs` |
| Phases (default order) | `prePhases unpackPhase patchPhase preConfigurePhases configurePhase preBuildPhases buildPhase checkPhase preInstallPhases installPhase fixupPhase installCheckPhase preDistPhases distPhase postPhases`. Override a phase with `xPhase = ''...''` but **start with `runHook preX` and end with `runHook postX`** so downstream hooks still fire. Prefer `postX`/`preX` over replacing whole phases |
| Phase toggles | `dontUnpack`, `dontPatch`, `dontConfigure`, `dontBuild`, `dontInstall`, `dontFixup`, `doCheck`, `doInstallCheck`, `doDist`. `patches` list, `patchFlags` (default `-p1`), `configureFlags`, `makeFlags`/`buildFlags`/`installFlags`. Use `*FlagsArray` (in shell, not as a derivation attr) when args contain spaces |
| configurePhase | Auto-adds `--prefix=$out`, `--disable-dependency-tracking`, `--disable-static`; disable individually with `dontAddPrefix`, `dontAddDisableDepTrack`, `dontDisableStatic`. `configurePlatforms` controls `--build/--host/--target` |
| fixupPhase | Moves `man`/`doc`/`info` to `share/`, strips binaries, runs `patchelf` (Linux) to prune RPATH, rewrites shebangs (`patchShebangs`). Toggles: `dontStrip`, `dontPatchELF`, `dontPatchShebangs`, `stripExclude = [ "*.rlib" ]` |
| Setup hooks | Any package can export a shell script (via `setupHook` attr) that reverse-deps source. Use `addEnvHooks "$hostOffset" fn` rather than hard-coding a specific hook array. stdenv ships `move-docs.sh`, `compress-man-pages.sh`, `strip.sh`, `patch-shebangs.sh`. `wrapProgram`/`makeWrapper` (add to `nativeBuildInputs`) wrap executables; `--prefix` hard-codes deps, `--suffix` allows runtime override |
| Multiple outputs | Set `outputs = [ "out" "dev" "lib" "doc" "man" ]`; the framework sorts files by group (`$outputDev`, `$outputBin`, etc.). "Binaries first" convention: executables in the first output (glibc is the deliberate exception — `libs` first). `setOutputFlags = false` if configure scripts reject the auto flags |
| passthru | Not passed to the builder, changing it doesn't rebuild. Conventional keys: `passthru.tests` (test derivations, run by ofBorg not Hydra), `passthru.updateScript` (auto-updates), `passthru.withPackages`/`optional-dependencies` |
| Shell functions in phases | `substitute` (`--replace-fail`/`--replace-warn`/`--replace-quiet`, `--subst-var`, `--subst-var-by`), `substituteInPlace`, `substituteAll` (replaces `@var@` from env; filters uppercase/underscore globals), `stripHash`, `prependToVar`/`appendToVar`, `remove-references-to`. Nix-level wrappers: `pkgs.substitute`, `pkgs.replaceVars` (errors on unreferenced `@...@` unless set to `null`), `pkgs.replaceVarsWith` |

**Dependency placement (the big gotcha):**

| Input | When it runs / purpose |
|---|---|
| `nativeBuildInputs` | Executed *during the build*: build tools on `$PATH` (`cmake`, `pkg-config`), setup hooks (`makeWrapper`), build-time interpreters |
| `buildInputs` | Linked/copied into the output / used at *runtime* (libraries like `zlib`). A dep can be in BOTH (e.g. `wayland`: lib at runtime + scanner at build) |
| `nativeCheckInputs` / `checkInputs` | Only injected when `doCheck = true` |
| `depsBuildBuild`, `depsBuildTarget`, `depsHostHost`, `depsTargetTarget` (+ `*Propagated`) | Only for compiler packaging; don't use otherwise |
| `strictDeps = true` | Disables the lenient placement that breaks cross-compilation; enabled by default in dlang/emacs/go/nim/ocaml/python/rust `build*` wrappers |
| `propagatedBuildInputs` | Use with care; obscures real inputs and runs setup hooks |

## Trivial build helpers

| Helper | Notes |
|---|---|
| `runCommand name args buildCommand` | Uses `stdenvNoCC` (no compiler); use `runCommandCC` only when a C compiler is needed; `runCommandLocal` forces local build (cheap <1s ops). `runCommandWith` is the base. Must create `$out` |
| `writeTextFile` family | Base for `writeText`, `writeTextDir`, `writeScript`, `writeScriptBin`, `writeShellScript` (adds bash shebang), `writeShellScriptBin`. `writeShellApplication` adds `runtimeInputs` (PATH at runtime), `runtimeEnv`, shellcheck + `bash -n` checks, and default `errexit nounset pipefail` |
| `symlinkJoin { name; paths; }` | Merges many derivations into one tree (may negate multi-output savings). `makeDesktopItem` + `copyDesktopItems` hook for .desktop files |
| `testers` namespace | `testVersion`, `hasPkgConfigModules`, `hasCmakeConfigModules`, `shellcheck`, `shfmt`, `testEqualDerivation`, `testEqualContents`, `invalidateFetcherByDrvHash`, `runNixOSTest`, `nixosTest` |

## Style guide (for docs/commit prose)

- Assume competence, not familiarity. Show, don't tell — lead with a working example.
- Imperative mood, active voice, present tense, address reader as "you".
- One sentence per line (semantic line breaks). No meta-commentary, no filler
  ("simply", "just", "in order to", "allows you to"). No nominalisations. Plain words.
- Sentence-case headings. Consistent terminology (repetition = clarity). Don't bury
  the negative — put limitations up front.
- `meta.description` rules: one short sentence, capitalised, no leading article, not
  the package name, no trailing punctuation, factual (no subjective language).

## Maintainer / meta conventions

| Topic | Rule |
|---|---|
| Maintainers | `maintainers = with lib.maintainers; [ alice bob ];` — defined in `maintainers/maintainer-list.nix`; add yourself in a separate `maintainers: add alice` commit in the same PR. `teams = with lib.teams; [ ... ];` from `team-list.nix` |
| `meta` keys | `description`, `longDescription` (CommonMark), `homepage`, `license`, `maintainers`, `teams`, `platforms`, `badPlatforms`, `broken`, `mainProgram`, `knownVulnerabilities`, `sourceProvenance`, `identifiers` (CPE/PURL), `hydraPlatforms`, `timeout`, `branch`, `changelog`, `downloadPage`, `donationPage`, `priority` |
| License | Single (`lib.licenses.gpl3Only`), `OR [ a b ]` (user picks), `AND [ a b ]` (all apply). Custom via `lib.licenses.mkLicense` only when no SPDX id exists |
| `meta.broken` | Can be conditional (e.g. `!(stdenv.buildPlatform.canExecute stdenv.hostPlatform)` for no-cross-compile). `meta` isn't passed to the builder, so changes don't trigger recompiles |

## Guidelines

| Guideline | Rationale |
|---|---|
| Prefer `pname`+`version` over `name`; prefer the `finalAttrs:` fixed-point form over `rec`; prefer `overrideAttrs` over `overrideDerivation`; prefer `override` for changing build options | Modern idioms |
| Never use `builtins.fetch*` in nixpkgs; always use `pkgs.fetch*`. Recompute the hash whenever a fetcher param changes | Fixed-output, build-time fetching |
| Place dependencies by *when they run*: build-time tools/hooks → `nativeBuildInputs`; runtime libraries → `buildInputs`. Set `strictDeps = true` for cross-safe packages | Cross-compilation safety |
| When overriding a phase, keep `runHook preX`/`runHook postX` bookends | Downstream hooks still fire |
| Use `--replace-fail` (not deprecated `--replace`) in `substitute`; with `replaceVars` set unused `@vars@` to `null` or they error | Correct substitution |
| Add `separateDebugInfo = true` via `overrideAttrs` (not `overrideDerivation`) | Processed by mkDerivation |
| Split outputs only where it helps; keep `out` as the catch-all; respect "binaries first" | Multi-output savings |
| For new top-level packages enable `__structuredAttrs` (preferred default; `passAsFile` is disabled under it) | Modern default |
| Mark provenance honestly: set `meta.sourceProvenance` (`binaryNativeCode` for AppImage / .deb wrappers, `binaryBytecode` for jars) and correct `license`/`broken` | Honesty |
| Keep `meta.description` to the style rules; list real maintainers/teams | Conventions |
| Check config keys offline: grep `doc/using/configuration.chapter.md` for exact key names before writing a `nixpkgs.config` block | Avoid invented keys |
| Hash discovery: set `hash = ""` (or `lib.fakeHash`), build, copy the `got:` hash. Same pattern for `cargoHash`, `npmDepsHash`, etc. | Standard workflow |
| Debug builds: `NIX_DEBUG=1..7`, `breakpointHook`, `--keep-failed`, run individual phases via `phases="buildPhase" genericBuild` in `nix-shell` | Debugging |
| Australian English in prose/comments; lowercase conventional-commit headers with an `Assisted-by:` trailer (per repo rules) | Repo convention |
