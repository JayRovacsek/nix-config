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
# The optional `frida` dependency (runtime instrumentation) is installed:
# upstream's `allowScripts` field in package.json permits its install
# script, which fetches the prebuilt frida-core binary.
{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nodejs_26,
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

  # The npm-deps cache already contains frida's built native module (its
  # install script ran during fetchNpmDeps, which has network access).
  # Re-running it in the sandboxed build phase would try to re-download the
  # frida toolchain from GitHub and fail, so skip scripts during rebuild.
  npmRebuildFlags = [ "--ignore-scripts" ];

  # `npm pack` (used by the install hook to stage the package into $out)
  # runs the `prepare` lifecycle script, which applies the release-please
  # devDependency patch via `git apply` and installs husky git hooks. Both
  # are repository-development concerns — upstream's published installs skip
  # them (the script self-detects missing dev dependencies) and they need
  # `git`, which is absent from the build sandbox — so pack with scripts
  # disabled; `dist/` and `skills/` are already produced by buildPhase.
  npmPackFlags = [ "--ignore-scripts" ];

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
