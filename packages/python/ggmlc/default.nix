{
  lib,
  python3Packages,
  fetchFromGitHub,
  cmake,
  ninja,
  makeWrapper,
  autoAddDriverRunpath,
  nix-update-script,
  config,
  cudaSupport ? config.cudaSupport,
  cudaPackages ? { },
  ...
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ggmlc";
  version = "0.9.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "monatis";
    repo = "ggmlc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dnJxf2Kax508EX87U+Dy01drbie1hgWDhOADbhidiC8=";
  };

  # Upstream builds the native CLI runners, the Laya System-1 binary and the
  # runtime test with CMake, but only installs the Python extension. Install them
  # into the wheel's scripts directory, which scikit-build-core maps to
  # `.data/scripts` and `pip` places on $PATH.
  postPatch = ''
    cat >> runtime/CMakeLists.txt <<'EOF'

    install(TARGETS ggmlc-run ggmlc-bench RUNTIME DESTINATION "''${SKBUILD_SCRIPTS_DIR}")
    if (GGMLC_BUILD_TESTS)
        install(TARGETS test-executor-cpu RUNTIME DESTINATION "''${SKBUILD_SCRIPTS_DIR}")
    endif()
    EOF

    cat >> examples/laya/CMakeLists.txt <<'EOF'

    install(TARGETS laya RUNTIME DESTINATION "''${SKBUILD_SCRIPTS_DIR}")
    EOF
  '';

  build-system = with python3Packages; [
    nanobind
    scikit-build-core
  ];

  nativeBuildInputs = [
    cmake
    ninja
    makeWrapper
  ]
  ++ lib.optionals cudaSupport [ autoAddDriverRunpath ];

  buildInputs = lib.optionals cudaSupport (
    with cudaPackages;
    [
      cuda_cudart
      cccl
      libcublas
    ]
  );

  dependencies = with python3Packages; [
    numpy
  ];

  # ggmlc builds its native extension with CMake, driven by scikit-build-core.
  # Disable the CMake setup hook's configure phase so it cannot change into a
  # build directory before the Python build hook (which expects to run from the
  # source root) executes.
  dontUseCmakeConfigure = true;

  cmakeFlags = [
    # Do not emit -march=native / -mcpu=native; builds must be reproducible.
    (lib.cmakeBool "GGML_NATIVE" false)
    # Build the Laya System-1 example, but not the other examples, which require
    # models to be downloaded at runtime.
    (lib.cmakeBool "GGMLC_BUILD_EXAMPLES" true)
    (lib.cmakeBool "GGMLC_BUILD_EXAMPLE_LAYA" true)
    (lib.cmakeBool "GGMLC_BUILD_EXAMPLE_TAB_COMPLETION" false)
    (lib.cmakeBool "GGMLC_BUILD_EXAMPLE_TIMESFM" false)
    # Build the native runtime test so the packaged runtime can be exercised.
    (lib.cmakeBool "GGMLC_BUILD_TESTS" true)
  ]
  ++ lib.optionals cudaSupport [
    (lib.cmakeBool "GGMLC_ENABLE_CUDA" true)
    (lib.cmakeFeature "CUDAToolkit_ROOT" "${lib.getDev cudaPackages.cuda_nvcc}")
    (lib.cmakeFeature "CMAKE_CUDA_COMPILER" "${lib.getExe cudaPackages.cuda_nvcc}")
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaPackages.flags.cmakeCudaArchitecturesString)
  ];

  postInstall = ''
    # Upstream's `ggmlc` console script targets `ggmlc.cli:main`, which does not
    # exist in this release. The documented user-facing entry point is the
    # native `ggmlc-run` runner, so wrap the console command onto it.
    rm -f "$out/bin/ggmlc"
    makeWrapper "$out/bin/ggmlc-run" "$out/bin/ggmlc"
  '';

  # Exercise the packaged binaries: run the native runtime test, then compile
  # and execute an example model through the packaged CLI runner. CUDA builds
  # link the NVIDIA driver, which is unavailable inside the build sandbox.
  doInstallCheck = true;

  installCheckPhase = lib.optionalString (!cudaSupport) ''
    runHook preInstallCheck

    # Native runtime test (runs an example MLP on the CPU backend).
    "$out/bin/test-executor-cpu"

    # Laya System-1 binary (needs no model for help/list-presets).
    "$out/bin/laya" help
    "$out/bin/laya" list-presets

    # Make the packaged Python module and its runtime dependency importable.
    export PYTHONPATH="$out/${python3Packages.python.sitePackages}:${python3Packages.numpy}/${python3Packages.python.sitePackages}''${PYTHONPATH:+:$PYTHONPATH}"

    # Compile a tiny example model to GGUF using the packaged Python API.
    python - <<'PY'
    import numpy as np

    from ggmlc.dialect.ggml.lowering import lower_to_ggml
    from ggmlc.ir.graph import Graph
    from ggmlc.ir.op import OpCode
    from ggmlc.ir.shape import Shape
    from ggmlc.ir.tensor import DType, StorageClass
    from ggmlc.serialization.gguf import serialize_to_gguf

    graph = Graph("example_mlp")
    x = graph.add_tensor("x", Shape([1, 4]), DType.F32, StorageClass.INPUT)
    w = graph.add_tensor("w", Shape([4, 4]), DType.F32, StorageClass.PARAMETER)
    b = graph.add_tensor("b", Shape([4]), DType.F32, StorageClass.PARAMETER)
    out = graph.add_tensor("out", Shape([1, 4]), DType.F32, StorageClass.ACTIVATION)
    w.data = np.eye(4, dtype=np.float32)
    b.data = np.full(4, 0.5, dtype=np.float32)
    graph.add_node(OpCode.LINEAR, inputs=[x.id, w.id, b.id], outputs=[out.id])
    graph.inputs = [x.id]
    graph.outputs = [out.id]
    graph.parameters = [w.id, b.id]

    with open("example_mlp.gguf", "wb") as gguf:
        gguf.write(serialize_to_gguf(lower_to_ggml(graph)))
    np.array([[1.0, 2.0, 3.0, 4.0]], dtype=np.float32).tofile("x.bin")
    PY

    # Execute the model through the packaged CLI runner.
    "$out/bin/ggmlc-run" info example_mlp.gguf
    "$out/bin/ggmlc-run" run example_mlp.gguf --input x:x.bin --output 3:out.bin

    python - <<'PY'
    import numpy as np

    result = np.fromfile("out.bin", dtype=np.float32)
    np.testing.assert_allclose(result, [1.5, 2.5, 3.5, 4.5])
    print("example model executed via ggmlc-run:", result)
    PY

    runHook postInstallCheck
  '';

  optional-dependencies = with python3Packages; {
    all = [
      flax
      jax
      jaxlib
      keras
      keras-hub
      mermaidx
      scipy
      sentence-transformers
      torch
      torchvision
      tqdm
      transformers
    ];
    dev = [
      flax
      jax
      jaxlib
      keras
      keras-hub
      laya
      mermaidx
      myst-parser
      nanobind
      pytest
      pytest-cov
      ruff
      scikit-build-core
      scipy
      sentence-transformers
      sphinx
      sphinx-autodoc-typehints
      sphinx-copybutton
      sphinx-rtd-theme
      torch
      torchvision
      tqdm
      transformers
    ];
    docs = [
      myst-parser
      sphinx
      sphinx-autodoc-typehints
      sphinx-copybutton
      sphinx-rtd-theme
    ];
    jax = [
      flax
      jax
      jaxlib
      keras
      keras-hub
      mermaidx
    ];
    torch = [
      mermaidx
      torch
    ];
  };

  pythonImportsCheck = lib.optionals (!cudaSupport) [
    "ggmlc"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A multi-framework neural network compiler lowering PyTorch, JAX, Flax, and Keras models to portable, high-performance GGML execution";
    homepage = "https://github.com/monatis/ggmlc";
    changelog = "https://github.com/monatis/ggmlc/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "ggmlc-run";
  };
})
