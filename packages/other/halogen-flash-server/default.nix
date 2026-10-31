{
  lib,
  stdenv,
  autoPatchelfHook,
  curl,
  dockerTools,
  fetchFromGitHub,
  jq,
  makeWrapper,
  nix,
  nix-prefetch-docker,
  rocmPackages,
  python3,
  writeShellScript,
  ...
}:
let
  version = "0.18.21";

  # The engine is closed-source (Peonist EULA): the only published artefact
  # is the OCI image, so the prebuilt ELF binaries are vendored from it.
  # pullImage speaks the registry API via skopeo (no Docker daemon needed).
  image = dockerTools.pullImage {
    imageName = "ghcr.io/peonist-ai/halogen-flash-server";
    imageDigest = "sha256:21006e5347f974241fd11e7bac5fc31759a4187f8267f7b52d8b564986b69821";
    sha256 = "sha256-vIKv/zxO1RhVYWOqiQjXqeuZrR7kTo/szFrLth+XS7Y=";
    finalImageName = "halogen-flash-server";
    finalImageTag = version;
  };

  repo = fetchFromGitHub {
    owner = "peonist-ai";
    repo = "halogen-flash-server";
    rev = "v${version}";
    sha256 = "1cznd2k5w89bimf405va49gd6mq48591qmqy1icd2axz6n8fd77p";
  };

  # serve_api.py and the bundled tools import the fastapi/starlette/pydantic
  # web stack plus numpy (uvicorn is imported at serve time), and
  # halogen_tools.py plus the entrypoint's hub helpers import transformers
  # and huggingface_hub. The image ships these in its site-packages; the nix
  # build composes them onto the interpreter instead of running it bare.
  pythonEnv = python3.withPackages (ps: [
    ps.fastapi
    ps."huggingface-hub"
    ps.jinja2
    ps.numpy
    ps.pydantic
    ps.starlette
    ps.transformers
    ps.uvicorn
  ]);

  # Bumps every pinned source in this file in one pass, for `nix-update
  # --flake --use-update-script halogen-flash-server` (or standalone from the
  # repo root). nix-update's native fetchers cover the fetchFromGitHub part
  # but not dockerTools.pullImage, so the script drives the prefetch tools
  # itself and rewrites all four values (version, repo hash, image digest,
  # image hash):
  #
  #   - version + repo hash: newest GitHub tag, hashed with nix-prefetch-url
  #     --unpack (the fetchzip hash fetchFromGitHub expects).
  #   - image digest + hash: nix-prefetch-docker with the same final name/tag
  #     the derivation uses (they are embedded in the docker-archive and
  #     affect the hash).
  #
  # UPDATE_NIX_VERSION overrides the discovered tag for targeted runs.
  updateScript = writeShellScript "update-halogen-flash-server" ''
    set -euo pipefail

    file="packages/other/halogen-flash-server/default.nix"
    if [ ! -f "$file" ]; then
      echo "error: $file not found (run from the nix-config repo root)" >&2
      exit 1
    fi

    # Current values, read straight from the expression (single source of truth).
    old_version=$(sed -n 's/^  version = "\(.*\)";$/\1/p' "$file" | head -n 1)
    old_repo_sha=$(sed -n '/repo = fetchFromGitHub {/,/^  };$/s/^    sha256 = "\(.*\)";$/\1/p' "$file")
    old_digest=$(sed -n 's/^    imageDigest = "\(.*\)";$/\1/p' "$file")
    old_image_sha=$(sed -n '/image = dockerTools.pullImage {/,/^  };$/s/^    sha256 = "\(.*\)";$/\1/p' "$file")
    for value in "$old_version" "$old_repo_sha" "$old_digest" "$old_image_sha"; do
      if [ -z "$value" ]; then
        echo "error: failed to parse the current pins from $file" >&2
        exit 1
      fi
    done

    # Newest upstream tag; UPDATE_NIX_VERSION overrides for targeted runs.
    new_version="''${UPDATE_NIX_VERSION:-$(curl -fsSL https://api.github.com/repos/peonist-ai/halogen-flash-server/tags | jq -r '.[].name' | sed 's/^v//' | sort -V | tail -n 1)}"

    if [ "$new_version" = "$old_version" ]; then
      echo "halogen-flash-server: already at $old_version"
      exit 0
    fi
    echo "halogen-flash-server: $old_version -> $new_version"

    # fetchFromGitHub (fetchzip) hash for the new tag.
    new_repo_sha=$("${nix}/bin/nix-prefetch-url" --unpack "https://github.com/peonist-ai/halogen-flash-server/archive/v''${new_version}.tar.gz" 2>/dev/null)

    # Registry digest + pullImage hash, with the same final name/tag the
    # derivation uses (they are embedded in the docker-archive and affect
    # the hash). Keep the download inside the project's .tmp, not /tmp.
    mkdir -p .tmp
    export TMPDIR="$PWD/.tmp"
    image_json=$("${nix-prefetch-docker}/bin/nix-prefetch-docker" \
      --image-name ghcr.io/peonist-ai/halogen-flash-server \
      --image-tag "$new_version" \
      --final-image-name halogen-flash-server \
      --final-image-tag "$new_version" \
      --json --quiet)
    new_digest=$(jq -r .imageDigest <<<"$image_json")
    new_image_sha=$(jq -r .hash <<<"$image_json")

    sed -i \
      -e "s/^  version = \"$old_version\";$/  version = \"$new_version\";/" \
      -e "s|$old_repo_sha|$new_repo_sha|" \
      -e "s|$old_digest|$new_digest|" \
      -e "s|$old_image_sha|$new_image_sha|" \
      "$file"
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "halogen-flash-server";
  inherit version;

  src = repo;

  nativeBuildInputs = [
    autoPatchelfHook
    jq
    makeWrapper
  ];

  # flash_serve and halogen-tools link libamdhip64.so.7 and
  # libhipblaslt.so.1; their Debian RUNPATH is rewritten to these.
  # stdenv.cc.cc.lib supplies libstdc++/libgcc_s, which the Debian-built
  # binaries also need. halogen-npu also needs libxrt_coreutil.so.2
  # (AMD XRT), which nixpkgs does not carry and the image itself does not
  # bundle either -- NPU mode expects it from the host, so the missing dep
  # is tolerated.
  buildInputs = [
    rocmPackages.clr
    rocmPackages.hipblaslt
    stdenv.cc.cc.lib
  ];
  autoPatchelfIgnoreMissingDeps = [ "libxrt_coreutil.so.2" ];

  dontConfigure = true;
  # Vendored prebuilt ELFs: keep them as upstream ships them (the EULA
  # requires unmodified redistribution) and skip stripping a 32 MB binary.
  dontStrip = true;

  # Merge the image's layers into a rootfs, applying OCI whiteouts, then
  # install the application files. The Debian base tree is not installed;
  # only the halogen payload is, with its ELF RUNPATHs patched to nixpkgs.
  buildPhase = ''
    runHook preBuild

    mkdir -p archive rootfs
    tar -xf ${image} -C archive

    for layer in $(jq -r '.[0].Layers[]' archive/manifest.json); do
      mkdir -p layer
      tar -xf "archive/$layer" -C layer
      # Whiteout files are mode 0000; make the tree readable so the
      # layer can be copied once its markers have been applied.
      chmod -R u+rX layer

      # Opaque directories replace everything the previous layers put
      # in them; then named whiteouts remove their targets.
      for opq in $(find layer -name '.wh..wh..opq'); do
        rel="''${opq#layer/}"
        if [ -d "rootfs/''${rel%/*}" ]; then
          find "rootfs/''${rel%/*}" -mindepth 1 ! -name '.wh.*' -delete
        fi
      done
      for wh in $(find layer -name '.wh.*' ! -name '.wh..wh..opq'); do
        rel="''${wh#layer/}"
        base="''${rel##*/}"
        rm -rf "rootfs/''${rel%/*}/''${base#.wh.}"
      done

      # Drop the markers, then merge the layer's real files in.
      find layer -name '.wh.*' -delete
      cp -a layer/. rootfs/
      rm -rf layer
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/libexec $out/opt/halogen/npu $out/share/halogen

    # Engine binaries, vendored from the upstream image.
    cp rootfs/usr/local/bin/flash_serve $out/bin/flash_serve
    cp rootfs/usr/local/bin/halogen-tools $out/bin/halogen-tools
    cp rootfs/usr/local/bin/halogen-npu $out/bin/halogen-npu
    cp rootfs/usr/local/bin/halogen-healthcheck $out/bin/halogen-healthcheck
    chmod +w $out/bin/*

    # Tuning plan, draft vocab and NPU model pins.
    cp rootfs/opt/halogen/flash-tune.plan $out/opt/halogen/flash-tune.plan
    cp rootfs/opt/halogen/draft-vocab.lists $out/opt/halogen/draft-vocab.lists
    cp rootfs/opt/halogen/npu/models.txt $out/opt/halogen/npu/models.txt

    # Serving front-end and tooling (Python).
    cp -r rootfs/halogen/tools $out/share/halogen/tools

    # The repo's entrypoint with its hardcoded image paths rewritten to
    # this output.
    # Double quotes so the shell expands $out to this output path; single
    # quotes left the literal text `$out` in the script, which trips
    # `set -u` wherever the entrypoint references it outside a function
    # that defines a local `out`.
    sed \
      -e "s|/usr/local/bin/flash_serve|$out/bin/flash_serve|g" \
      -e "s|/usr/local/bin/halogen-tools|$out/bin/halogen-tools|g" \
      -e "s|/usr/local/bin/halogen-npu|$out/bin/halogen-npu|g" \
      -e "s|/usr/local/bin/halogen-healthcheck|$out/bin/halogen-healthcheck|g" \
      -e "s|/opt/halogen|$out/opt/halogen|g" \
      -e "s|/halogen/tools|$out/share/halogen/tools|g" \
      -e "s|python3|${pythonEnv}/bin/python3|g" \
      $src/deploy/entrypoint.sh > $out/libexec/halogen-entrypoint.sh
    chmod +x $out/libexec/halogen-entrypoint.sh

    # Launcher: entrypoint plus the image-borne ENV defaults (each still
    # overridable from the environment).
    makeWrapper $out/libexec/halogen-entrypoint.sh \
      $out/bin/halogen-flash-server \
      --run 'export HALOGEN_ARCH="''${HALOGEN_ARCH:-gfx1151}"' \
      --run 'export HIP_FORCE_DEV_KERNARG="''${HIP_FORCE_DEV_KERNARG:-1}"' \
      --run 'export HALOGEN_ATTN_FA="''${HALOGEN_ATTN_FA:-64}"' \
      --run 'export HALOGEN_PROMPT_CACHE="''${HALOGEN_PROMPT_CACHE:-2}"' \
      --run 'export HALOGEN_PREFILL_CHUNK="''${HALOGEN_PREFILL_CHUNK:-32768}"' \
      --run 'export HALOGEN_KV_SLOTS="''${HALOGEN_KV_SLOTS:-4}"' \
      --run 'export HALOGEN_CTX="''${HALOGEN_CTX:-262144}"' \
      --run 'export HALOGEN_MAX_TOK="''${HALOGEN_MAX_TOK:-32768}"' \
      --run 'export HALOGEN_MATMUL_ALGOS="''${HALOGEN_MATMUL_ALGOS:-1}"' \
      --run 'export HALOGEN_MATMUL_BUCKET="''${HALOGEN_MATMUL_BUCKET:-1}"' \
      --run 'export HALOGEN_MATMUL_TUNING_FILE="''${HALOGEN_MATMUL_TUNING_FILE:-${builtins.placeholder "out"}/opt/halogen/flash-tune.plan}"' \
      --run 'export HALOGEN_DRAFT_VOCAB_FILE="''${HALOGEN_DRAFT_VOCAB_FILE:-${builtins.placeholder "out"}/opt/halogen/draft-vocab.lists}"' \
      --run 'export _hg_hf="''${_hg_hf:-${pythonEnv}/bin/hf}"' \
      --run 'export HALOGEN_TOKENIZER="''${HALOGEN_TOKENIZER:-/tokenizer}"' \
      --run 'export HALOGEN_PORT="''${HALOGEN_PORT:-8730}"' \
      --run 'export HALOGEN_BIND="''${HALOGEN_BIND:-127.0.0.1}"' \
      --run 'export HALOGEN_API_PORT="''${HALOGEN_API_PORT:-8731}"' \
      --run 'export HALOGEN_MAX_TOKENS_CAP="''${HALOGEN_MAX_TOKENS_CAP:-65536}"' \
      --run 'export HALOGEN_QUEUE_TIMEOUT="''${HALOGEN_QUEUE_TIMEOUT:-3600}"' \
      --run 'export HALOGEN_IMAGE_VERSION="${version}"' \
      --run 'export HALOGEN_IMAGE_MODES="''${HALOGEN_IMAGE_MODES:-all engine api bench sweep convert inspect verify ppl niah}"' \
      --run 'export PYTHONUNBUFFERED="''${PYTHONUNBUFFERED:-1}"' \
      --run 'export HF_HUB_OFFLINE="''${HF_HUB_OFFLINE:-1}"' \
      --run 'export TRANSFORMERS_VERBOSITY="''${TRANSFORMERS_VERBOSITY:-error}"'

    patchShebangs $out/libexec $out/bin

    # The EULA requires its licence texts to travel with the software.
    mkdir -p $out/share/licenses/halogen-flash-server
    cp $src/LICENSE.md $out/share/licenses/halogen-flash-server/LICENSE.md
    cp $src/THIRD-PARTY-NOTICES.md \
      $out/share/licenses/halogen-flash-server/THIRD-PARTY-NOTICES.md

    runHook postInstall
  '';

  passthru = {
    inherit updateScript;
  };

  meta = {
    description = "Qwen3.8-Flash-Next inference server for AMD Strix Halo";
    homepage = "https://github.com/peonist-ai/halogen-flash-server";
    license = lib.licenses.unfreeRedistributable;
    platforms = [ "x86_64-linux" ];
    mainProgram = "halogen-flash-server";
    sourceRepos = [ "https://github.com/peonist-ai/halogen-flash-server" ];
  };
})
