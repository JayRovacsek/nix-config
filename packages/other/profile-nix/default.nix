{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "nix-eval-profile";
  runtimeInputs = with pkgs; [
    nix
    flamegraph
    speedscope
    coreutils
    gnused
  ];

  text = ''
    set -euo pipefail

    if [ "$#" -lt 1 ]; then
      echo "Usage: nix run .#profile -- <flake-ref or nix expr>"
      exit 1
    fi

    TARGET="$1"
    shift || true

    OUTDIR="$(pwd)/nix-profile"
    ${pkgs.coreutils}/bin/mkdir -p "$OUTDIR"

    PROFILE="$OUTDIR/profile.folded"
    SVG="$OUTDIR/profile.svg"

    echo "▶ Profiling evaluation of: $TARGET"
    echo "▶ Output directory: $OUTDIR"

    # Evaluation-only, no builds, pure
    ${pkgs.nix}/bin/nix eval \
      --eval-profiler flamegraph \
      --eval-profiler-frequency 99 \
      --eval-profile-file "$PROFILE" \
      "$TARGET" \
      >/dev/null

    echo "▶ Generating flamegraph"
    ${pkgs.flamegraph}/bin/flamegraph.pl "$PROFILE" > "$SVG"

    echo "▶ Converting to Speedscope"
    ${pkgs.coreutils}/bin/cat "$PROFILE" | ${pkgs.speedscope}/bin/speedscope -

    echo "✔ Done"
    echo "  Flamegraph:  $SVG"
  '';
}
