# OpenShell CLI, gateway and policy prover built from source.
# Upstream: https://github.com/NVIDIA/OpenShell (v0.1.3).
# nixpkgs only ships the CLI (and lags upstream), so the gateway and prover
# binaries required by the home-manager module are built here.
{
  lib,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  rustPlatform,
  pkg-config,
  protobuf,
  z3,
  ...
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "openshell";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "OpenShell";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7cIJ6YbBWev+C4uo2wxGer+nEpE3hxPEejC+BSo/VDc=";
  };

  cargoHash = "sha256-V1EB2O31opEYm01BC2yYGejgDrVAzTDJEEbZOy9fUVI=";

  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${finalAttrs.version}"'

    # openshell-core's only default feature is telemetry. Several crates pull
    # it in with defaults, re-enabling telemetry through feature unification,
    # so disable defaults everywhere to compile it out.
    for f in crates/*/Cargo.toml; do
      sed -i '/default-features = false/!s|path = "../openshell-core"|path = "../openshell-core", default-features = false|' "$f"
    done

    # Use nixpkgs protoc rather than the vendored prebuilt binary.
    for f in crates/*/build.rs; do
      substituteInPlace "$f" \
        --replace-quiet 'protoc_bin_vendored::protoc_bin_path()?' '"${protobuf}/bin/protoc"' \
        --replace-quiet 'protoc_bin_vendored::include_path()?' '"${protobuf}/include"'
    done
  '';

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [ z3 ];

  # Anonymous upstream telemetry is disabled at compile time.
  buildNoDefaultFeatures = true;
  buildFeatures = [ "openshell-gateway/in-tree-compute-drivers" ];

  cargoBuildFlags = [
    "-p"
    "openshell-cli"
    "-p"
    "openshell-gateway"
    "-p"
    "openshell-prover-cli"
  ];

  env.OPENSHELL_IMAGE_TAG = finalAttrs.version;

  # Upstream tests require docker, network access and git.
  doCheck = false;

  # Same pattern as nixpkgs gh/ripgrep; skipped when cross compiling.
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd openshell \
      --bash <($out/bin/openshell completions bash) \
      --fish <($out/bin/openshell completions fish) \
      --zsh <($out/bin/openshell completions zsh)
  '';

  meta = {
    description = "Safe, private runtime for autonomous AI agents";
    homepage = "https://docs.nvidia.com/openshell";
    license = lib.licenses.asl20;
    mainProgram = "openshell";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
