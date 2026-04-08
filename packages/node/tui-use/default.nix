{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nodejs,
  python3,
}:
let
  pname = "tui-use";
  version = "0.1.17";

  # TUI automation for AI agents — like BrowserUse, but for the terminal.
  # Gives agents access to interactive terminal programs (REPLs, installers,
  # TUI apps) via PTY automation.
  # https://github.com/onesuper/tui-use
  meta = with lib; {
    homepage = "https://github.com/onesuper/tui-use";
    description = "TUI automation for AI agents — like BrowserUse, but for the terminal";
    license = licenses.mit;
    mainProgram = "tui-use";
  };

  src = fetchFromGitHub {
    owner = "onesuper";
    repo = "tui-use";
    rev = "6ef66f1e723132bbfe8cb2e7f3dd31ad19e5b69e";
    hash = "sha256-6vLaACk6qVQ0m53v7qojEioB8MhjU/qSbuzrjcPVeEw=";
  };

  npmDepsHash = "sha256-fDBf15Y4fMHwvfBuQMd9DI38gIMjH0FndtWTjJsUrKg=";

  patches = [ ./add-lockfile.patch ];

  # node-pty requires native compilation; disable the upstream postinstall
  # script which tries to manage prebuilt binaries — nix handles this via
  # node-gyp during the npm build phase.
  dontNpmPrune = true;

in
buildNpmPackage {
  inherit
    pname
    version
    patches
    dontNpmPrune
    src
    meta
    nodejs
    npmDepsHash
    ;

  nativeBuildInputs = [ python3 ];

  # Disable the postinstall script that tries to manage prebuilt binaries.
  # node-gyp will compile node-pty natively during the npm install phase.
  npmFlags = [ "--ignore-scripts" ];

  # After npm install (with --ignore-scripts), manually rebuild node-pty
  # so the native addon is compiled for the target platform.
  preBuild = ''
    npm rebuild node-pty
  '';

  # The build script runs: tsc && chmod +x dist/cli.js
  npmBuildScript = "build";
}
