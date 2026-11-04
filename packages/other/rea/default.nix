# REA — Reverse Engineer Anything (morluto/rea)
#
# Upstream: https://github.com/morluto/rea (MIT)
#
# REA is a single MCP server (plus CLI) for reverse engineering native
# binaries, managed assemblies, JavaScript/Electron apps, archives,
# firmware and browser targets. The `rea`/`rea-agents` bin is a plain ESM
# entry script (`scripts/rea.mjs`) backed by the compiled `dist/` output.
#
# Pinned to the `rea-agents-6.8.0` release tag
# (commit 160d821ac9a0310afcb8d1fc427862dd6508add5) — a static upstream
# revision per the extension supply chain policy. The upstream npx-based
# `setup` installer is deliberately not used; everything flows through
# this derivation.
#
# Node runtime: the upstream `engines` field requires
# `^22.23.4 || ^24.22.1 || >=26.12.1`. The default `nodejs` in the pinned
# nixpkgs is 24.21.0 (too old), so `nodejs_26` (26.12.1) is selected
# explicitly.
#
# Frida (runtime instrumentation): the npm `frida` dependency's native
# binding is fetched by its install script from GitHub releases and never
# lands in the packed output (the registry cache ships the JS wrapper
# only), so the `frida` CLI is provided by nixpkgs' `frida-tools` and
# propagated from this package instead.
#
# NixOS host support: upstream's `supportsReaHost` (src/application/
# LinuxHopper.ts) only recognises distributions with a deb/rpm/arch
# package family and reports NixOS as `unsupported_host` in `rea doctor`
# — upstream even asserts that in LinuxHopper.test.ts. postPatch extends
# the predicate to recognise NixOS (the package itself comes from nixpkgs
# rather than a distro package family) and flips the upstream test
# assertion to match.
#
# FHS tool paths: upstream references host tools via absolute /usr paths
# (shebangs, spawn targets, X11 helpers). postPatch rewrites them to the
# corresponding nixpkgs store paths so the compiled dist/ and the shipped
# scripts resolve them on NixOS. macOS-only paths (xcrun, codesign,
# hdiutil, ...) and the Hopper launcher candidates (/usr/bin/hopper,
# /opt/hopper*) are left untouched: they are probed conditionally on the
# host OS and Hopper has no nixpkgs equivalent. Browser binaries
# (/usr/bin/chromium etc.) are likewise left alone — browsers are
# detected on PATH instead.
{
  buildNpmPackage,
  coreutils,
  fetchFromGitHub,
  frida-tools,
  gdb,
  lib,
  nodejs_26,
  python3,
  util-linux,
  xauth,
  xvfb,
  ...
}:
buildNpmPackage rec {
  pname = "rea-agents";
  version = "6.8.0";

  src = fetchFromGitHub {
    owner = "morluto";
    repo = "rea";
    rev = "rea-agents-6.8.0";
    hash = "sha256-2ADn3U3lvUoB4tCEpzO0rMfYE4sis+5uBiEazcp0gpI=";
  };

  # Upstream targets Node 26 (see header comment); the default `nodejs`
  # (24.x) in the pinned nixpkgs does not satisfy the declared engines.
  nodejs = nodejs_26;

  npmDepsHash = "sha256-3WPXD+qm5WVfrTEvepKwX5RZBfbLBcPB0uDmKIx4MR8=";

  # Tools whose /usr/bin references are rewritten to store paths in
  # postPatch (see header comment); listed here so the dependency is
  # explicit rather than only interpolated.
  buildInputs = [
    coreutils
    gdb
    python3
    util-linux
    xauth
    xvfb
  ];

  # The `frida` CLI (see header comment); propagated so consumers of this
  # package get it on PATH at runtime.
  propagatedBuildInputs = [ frida-tools ];

  # Re-running install scripts in the sandboxed build phase would make
  # frida re-download its native binding from GitHub (not served by the
  # npm registry cache), so skip scripts during rebuild.
  npmRebuildFlags = [ "--ignore-scripts" ];

  # `npm pack` (used by the install hook to stage the package into $out)
  # runs the `prepare` lifecycle script, which applies the release-please
  # devDependency patch via `git apply` and installs husky git hooks. Both
  # are repository-development concerns — upstream's published installs skip
  # them (the script self-detects missing dev dependencies) and they need
  # `git`, which is absent from the build sandbox — so pack with scripts
  # disabled; `dist/` and `skills/` are already produced by buildPhase.
  npmPackFlags = [ "--ignore-scripts" ];

  # Rewrites the hardcoded FHS tool paths and the NixOS host-support gate
  # (see header comment). The path rules run on the source tree so the
  # compiled dist/ inherits them; the `env node`/`env python3` shebang
  # forms are rewritten before the bare `/usr/bin/env` so they point at
  # the actual interpreters rather than coreutils' env. Dependencies' own
  # FHS references are not touched: `node_modules` is installed after
  # patching, from the npm cache.
  postPatch = ''
    # --- NixOS host support -------------------------------------------------
    # Upstream gates `rea doctor` on a recognised deb/rpm/arch package
    # family; extend the predicate to recognise NixOS and flip the upstream
    # test assertion that pins the old behaviour.
    sed -i \
      's/): boolean => distribution?.packageFamily !== undefined;/): boolean => distribution?.packageFamily !== undefined || distribution?.id === "nixos";/' \
      src/application/LinuxHopper.ts
    sed -i \
      -e 's/withholds host support from a distribution with no package family"/grants host support to NixOS but not an unknown host"/' \
      -e '/ID=nixos/,+1 s/false/true/' \
      src/application/LinuxHopper.test.ts

    # --- FHS tool paths -------------------------------------------------------
    grep -rlI -E '/usr/bin/(env|python3|gdb|prlimit|unshare|mount|true|Xvfb|xauth)' \
      src scripts bridge .agents install.sh | while IFS= read -r f; do
      sed -i \
        -e 's|/usr/bin/env node|${nodejs_26}/bin/node|g' \
        -e 's|/usr/bin/env python3|${python3}/bin/python3|g' \
        -e 's|/usr/bin/python3|${python3}/bin/python3|g' \
        -e 's|/usr/bin/env|${coreutils}/bin/env|g' \
        -e 's|/usr/bin/true|${coreutils}/bin/true|g' \
        -e 's|/usr/bin/prlimit|${util-linux}/bin/prlimit|g' \
        -e 's|/usr/bin/unshare|${util-linux}/bin/unshare|g' \
        -e 's|/usr/bin/mount|${util-linux}/bin/mount|g' \
        -e 's|/usr/bin/gdb|${gdb}/bin/gdb|g' \
        -e 's|/usr/bin/Xvfb|${xvfb}/bin/Xvfb|g' \
        -e 's|/usr/bin/xauth|${xauth}/bin/xauth|g' \
        "$f"
    done
  '';

  # `npm run compile` performs the TypeScript compilation (tsc -p
  # tsconfig.build.json plus the rolldown runtime bundle) that produces the
  # `dist/` directory referenced by the bin entry. `npm run build` then
  # generates the `skills/` artefact bundle (from `.agents/skills/`) that
  # the published npm package ships; the raw skill sources under
  # `.agents/skills/` are installed as part of the source tree regardless.
  #
  # Upstream's run-typescript.mjs selects the native `tsrs` compiler when
  # tsrs's package.json advertises a platform binary. The prebuilt npm
  # binary cannot execute inside the Nix sandbox (its /lib64 interpreter is
  # not resolvable), so we strip the platform advertisement and let the
  # script take its documented fallback path: the pure-JS `typescript`
  # devDependency (the same path upstream uses on win32).
  buildPhase = ''
    runHook preBuild
    ${nodejs_26}/bin/node -e '
      const fs = require("fs");
      const p = "node_modules/tsrs/package.json";
      const pkg = JSON.parse(fs.readFileSync(p, "utf8"));
      pkg.optionalDependencies = {};
      fs.writeFileSync(p, JSON.stringify(pkg));
    '
    npm run compile
    npm run build
    runHook postBuild
  '';

  # The four auxiliary skills (rea-analysis-optimization,
  # rea-changelog-update, rea-ci-tests-audit, rea-tool-design) live only
  # under `.agents/skills/`, which upstream omits from the npm `files` list
  # (only the generated `skills/reverse-engineer-anything` artefact is
  # published). Copy the raw `.agents` tree into $out so every skill in the
  # upstream suite can be linked from the OpenCode module.
  postInstall = ''
    cp -r .agents "$out/lib/node_modules/rea-agents/.agents"
  '';

  meta = {
    homepage = "https://github.com/morluto/rea";
    description = "Reverse engineer anything with agents, from app behavior down to native binaries";
    license = lib.licenses.mit;
    mainProgram = "rea";
    platforms = [ "x86_64-linux" ];
  };
}
