{ self, pkgs }:
let
  inherit (pkgs) lib;
  inherit (lib) concatStringsSep;

  system = pkgs.stdenv.hostPlatform.system;

  # nix-update invokes `nix` purely via PATH (there is no flag to point it
  # elsewhere), so Lix is placed at the front of PATH and every nix
  # invocation nix-update makes resolves to it.
  lix = self.inputs.lix.packages.${system}.default;

  # --------------------------------------------------------------------------
  # Tunables
  # --------------------------------------------------------------------------

  # Packages to skip. Add a name here to disable it without touching anything
  # else. Two reasons a package lands here:
  #   * it has no upstream for nix-update to track (local writeShellScriptBin
  #     wrappers), or
  #   * its newer releases need a toolchain newer than the pinned nixpkgs
  #     provides, so nix-update bumps the version but cannot compute a valid
  #     hash (and a half-updated derivation is worse than none).
  disabledPackages = [
    # buildGoModule: newer releases require go >= 1.27.3, nixpkgs ships 1.26.10.
    "cloudquery"

    # Local writeShellScriptBin wrappers with no upstream source.
    "ditto-transform"
    "restic-cleanup"
    "restic-prepare"
    "vulnix-pre-commit"
    "waybar-colour-picker"
    "waybar-screenshot"
    "wofi-power"

    # Commit-pinned fetchFromGitHub packages whose upstream repos publish no
    # GitHub releases (verified: releases.atom is empty), so nix-update's
    # native fetchers raise VersionError with nothing to derive a version from.
    "opnreport"

    # All fetched from saimoomedits/eww-widgets (no releases); each widget
    # extracts a different script from the same commit-pinned source.
    "eww-battery"
    "eww-launch-bar"
    "eww-mem-ad"
    "eww-memory"
    "eww-music-info"
    "eww-pop"
    "eww-sleek-bar"
    "eww-wifi"
    "eww-workspace"

    # libyal Python bindings: newer PyPI releases ship wheels only (no .tar.gz
    # sdist), so fetchPypi 404s when nix-update recomputes the source hash.
    # Their GitHub releases carry the C library rather than the Python package,
    # so there is no fetchable source for the newer versions.
    "libbde-python"
    "libcaes-python"
    "libcreg-python"
    "libesedb-python"
    "libevt-python"
    "libevtx-python"
    "libewf-python"
    "libfcrypto-python"
    "libfsapfs-python"
    "libfsext-python"
    "libfshfs-python"
    "libfsntfs-python"
    "libfvde-python"
    "libfwsi-python"
    "liblnk-python"
    "libluksde-python"
    "libmodi-python"
    "libmsiecf-python"
    "libolecf-python"
    "libphdi-python"
    "libqcow-python"
    "libregf-python"
    "libscca-python"
    "libsigscan-python"
    "libsmdev-python"
    "libsmraw-python"
    "libvhdi-python"
    "libvmdk-python"
    "libvsgpt-python"
    "libvshadow-python"
    "libvslvm-python"

    # buildGoModule: pdscan 0.2.0 requires go >= 1.27, nixpkgs ships 1.26.10,
    # so the vendor hash cannot be computed.
    "pdscan"

    # velociraptor splits its version into `version` + `minor-version` for the
    # asset filename, which nix-update's single-version bump cannot reproduce.
    "velociraptor"

    # buildDotnetModule fetch-deps fails with a NuGet IOException
    # ('NuGet-Migrations'), so the nuget deps cannot be regenerated.
    "battlenet-lancache-prefill"
    "steam-lancache-prefill"

    # cst-lsp is already at the latest release (tag `v.0.1.3`); the non-standard
    # tag makes nix-update derive a malformed version (".0.1.3").
    "cst-lsp"
  ];

  # Packages that declare a real passthru.updateScript and therefore must be
  # updated with --use-update-script (buildDotnetModule regenerates its
  # nuget deps; the others ship a custom script). Everything else is updated
  # with nix-update's native fetchers. Passing --use-update-script to a
  # package that has no updateScript makes nix-update force-evaluate the whole
  # merged package set and fail, so the flag is scoped to exactly this list.
  # ggmlc is intentionally excluded here: its passthru.updateScript is the
  # generic nix-update-script, which does not propagate --flake, so running it
  # with --use-update-script falls back to a non-flake evaluation and fails on
  # a missing default.nix. A plain fetchFromGitHub needs no dependency
  # regeneration, so it is updated with the native fetchers instead.
  updateScriptPackages = [
    "battlenet-lancache-prefill"
    "epic-lancache-prefill"
    "steam-lancache-prefill"
    "halogen-flash-server"
  ];

  # --------------------------------------------------------------------------

  # Updatable set derived from the flake's own package categories. The text
  # configs, terranix stacks, resources, sd-images and disko are intentionally
  # omitted — they have no upstream for nix-update to track.
  nativePackages = lib.subtractLists updateScriptPackages (
    self.common.python-packages
    ++ self.common.go-packages
    ++ self.common.dotnet-packages
    ++ self.common.rust-packages
    ++ self.common.shell-packages
  );

  nativeFiltered = lib.subtractLists disabledPackages nativePackages;
  updateScriptFiltered = lib.subtractLists disabledPackages updateScriptPackages;

  nativeList = builtins.toFile "native-list" (concatStringsSep "\n" nativeFiltered + "\n");
  updateScriptList = builtins.toFile "update-script-list" (
    concatStringsSep "\n" updateScriptFiltered + "\n"
  );

  program = builtins.toString (
    pkgs.writers.writeBash "update-packages" ''
      set -u

      export PATH="${pkgs.nix-update}/bin:${lix}/bin''${PATH:+:$PATH}"
      # nix-update's update-script runner evaluates `import <nixpkgs>`, so
      # point that at the flake's pinned nixpkgs.
      export NIX_PATH="nixpkgs=${self.inputs.nixpkgs}''${NIX_PATH:+:$NIX_PATH}"

      # nix-update patches files relative to the current directory, so walk
      # up to the repository root before running.
      root="$PWD"
      while [ ! -f "$root/flake.nix" ] && [ "$root" != "/" ]; do
        root="$(cd "$root/.." && pwd)"
      done
      if [ ! -f "$root/flake.nix" ]; then
        echo "update-packages: no flake.nix found above $PWD" >&2
        exit 1
      fi
      cd "$root"

      # Extra flags forwarded to every nix-update invocation (e.g. --commit).
      extra=("$@")

      total=0
      failed=0
      failed_names=""

      update_one() {
        local name="$1"
        shift
        total=$((total + 1))
        echo ":: updating $name"
        if ! nix-update --flake "$@" "''${extra[@]}" "$name" < /dev/null; then
          failed=$((failed + 1))
          failed_names="$failed_names $name"
          # A failed run can leave the version bumped but the hash uncomputed.
          # Revert this package's files so a half-updated derivation cannot
          # poison the --strict evaluation of packages that depend on it.
          git checkout -- ":(glob)packages/**/$name/**" 2>/dev/null || true
        fi
      }

      # Packages that declare a passthru.updateScript: run it via
      # --use-update-script so their dependency hashes are regenerated too.
      while IFS= read -r name; do
        [ -n "$name" ] || continue
        update_one "$name" --use-update-script
      done < ${updateScriptList}

      # Everything else: rely on nix-update's native fetchers, with no
      # --use-update-script.
      while IFS= read -r name; do
        [ -n "$name" ] || continue
        update_one "$name"
      done < ${nativeList}

      echo ":: processed $total packages ($failed failures)"
      if [ -n "$failed_names" ]; then
        echo ":: failures:$failed_names"
      fi
      [ "$failed" -eq 0 ]
    ''
  );

  type = "app";

in
{
  update-packages = {
    inherit program type;
  };
}
