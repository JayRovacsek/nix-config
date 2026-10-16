{ pkgs, ... }:
pkgs.stdenv.mkDerivation {
  pname = "wshobson-agents";
  version = "unstable-2026-10-04";

  src = pkgs.fetchFromGitHub {
    owner = "wshobson";
    repo = "agents";
    rev = "46891e7e60da0e52baf1050b7b6391b64e84c6d9";
    hash = "sha256-vKawxqxGv0QygVztpMai7h4SXtK2JmmLEqCZ8hFr+qE=";
  };

  nativeBuildInputs = [ pkgs.python3 ];

  # Upstream is a multi-harness plugin marketplace whose OpenCode artifacts are
  # produced by its own pure-python adapter — the same generator that backs the
  # `make install-opencode` target. Run it here instead of hand-rolling the
  # transform, then expose the result under $out/share so consumers can read
  # agents/, skills/ and commands/ directly.
  buildPhase = ''
    runHook preBuild

    python3 tools/generate.py \
      --harness opencode \
      --all \
      --output-root "$TMPDIR/generated"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share"
    cp -r "$TMPDIR/generated/.opencode/." "$out/share/"

    # OpenCode subagents without a `model:` field inherit the model of the
    # invoking agent. Drop the adapter's hardcoded `anthropic/*` IDs so this
    # collection works across whichever providers a host actually has.
    #
    # The adapter also marks every agent `mode: subagent`, which hides it from
    # the primary-agent switcher. Promote them to `mode: all` so they are
    # selectable as primary agents too.
    #
    # Finally, drop the upstream `name:` so an agent's OpenCode name is taken
    # from the file name it is linked under. That lets a consumer disambiguate
    # the agents the plugin marketplace duplicates across plugins (OpenCode
    # falls back to the file name when no `name:` is present).
    ${pkgs.gnused}/bin/sed -i \
      -e '/^model: /d' \
      -e '/^name: /d' \
      -e 's/^mode: subagent$/mode: all/' \
      "$out/share/agents/"*.md

    runHook postInstall
  '';

  meta = {
    description = "A curated collection of Claude Code/OpenCode agents, skills and commands";
    homepage = "https://github.com/wshobson/agents";
    license = pkgs.lib.licenses.mit;
  };
}
