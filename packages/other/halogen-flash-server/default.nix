{
  lib,
  stdenv,
  autoPatchelfHook,
  dockerTools,
  fetchFromGitHub,
  jq,
  makeWrapper,
  rocmPackages,
  python312,
  ...
}:
let
  version = "0.18.18";

  # The engine is closed-source (Peonist EULA): the only published artefact
  # is the OCI image, so the prebuilt ELF binaries are vendored from it.
  # pullImage speaks the registry API via skopeo (no Docker daemon needed).
  image = dockerTools.pullImage {
    imageName = "ghcr.io/peonist-ai/halogen-flash-server";
    imageDigest = "sha256:d6cb2a7d20211da675cd1f104a02f4bf4cb60e29afffbaadf8b0d495d332cc8a";
    sha256 = "sha256-Oqkvr3m9pp28HU7T2w4OIRZJkBHUgizNq4jqwGeppgc=";
    finalImageName = "halogen-flash-server";
    finalImageTag = version;
  };

  repo = fetchFromGitHub {
    owner = "peonist-ai";
    repo = "halogen-flash-server";
    rev = "v${version}";
    sha256 = "0q7xn7v1ipda84062hks1vwqigx08hi9qxi21lz1n8s69pbfg6fq";
  };
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
  # halogen-npu also needs libxrt_coreutil.so.2 (AMD XRT), which nixpkgs
  # does not carry and the image itself does not bundle either -- NPU mode
  # expects it from the host, so the missing dep is tolerated.
  runtimeDependencies = [
    rocmPackages.clr
    rocmPackages.hipblaslt
  ];
  autoPatchelfIgnoreMissingDeps = [ "libxrt_coreutil.so.2" ];

  dontConfigure = true;

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
    sed \
      -e 's|/usr/local/bin/flash_serve|$out/bin/flash_serve|g' \
      -e 's|/usr/local/bin/halogen-tools|$out/bin/halogen-tools|g' \
      -e 's|/usr/local/bin/halogen-npu|$out/bin/halogen-npu|g' \
      -e 's|/usr/local/bin/halogen-healthcheck|$out/bin/halogen-healthcheck|g' \
      -e 's|/opt/halogen|$out/opt/halogen|g' \
      -e 's|/halogen/tools|$out/share/halogen/tools|g' \
      -e 's|python3|${python312}/bin/python3|g' \
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
      --run 'export HALOGEN_MATMUL_TUNING_FILE="''${HALOGEN_MATMUL_TUNING_FILE:-$out/opt/halogen/flash-tune.plan}"' \
      --run 'export HALOGEN_DRAFT_VOCAB_FILE="''${HALOGEN_DRAFT_VOCAB_FILE:-$out/opt/halogen/draft-vocab.lists}"' \
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

  meta = {
    description = "Qwen3.8-Flash-Next inference server for AMD Strix Halo";
    homepage = "https://github.com/peonist-ai/halogen-flash-server";
    license = lib.licenses.unfreeRedistributable;
    platforms = [ "x86_64-linux" ];
    mainProgram = "halogen-flash-server";
    sourceRepos = [ "https://github.com/peonist-ai/halogen-flash-server" ];
  };
})
