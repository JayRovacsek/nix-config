{ self, pkgs, ... }:
{
  imports = [ ../../options/modules/halogen-flash-server ];

  networking.firewall.allowedTCPPorts = [ 11435 ];

  services.halogen-flash-server = {
    enable = true;
    enableVision = true;
    hostAddress = "0.0.0.0";
    # Run the nix-built package directly instead of the upstream OCI image.
    runtime = "package";
    applyRecommendedSystemSettings = true;
    modelRepo = "Quat3rnion/halogen-qwen3.8-flash-next-v2-abliterated";
    # Historical r2 transplant — the combination the derivative's model card
    # validates against peonist's stock companions (n-gram 5cc17cea…,
    # tokenizer/vision e053f488…), which this repo does not publish and which
    # must be pulled from peonist-ai/halogen-qwen3.8-flash-next into modelDir.
    # HEAD (2fd96054…) carries the newer native v2 conversion, but its
    # compatibility with those stock companions is explicitly unvalidated.
    modelRevision = "e7783c5822dfda2785a0f5b435abf54df89fe8ee";
    checkpointFile = "qwen38-flash-next-v2-abliterated.hgn";
    # NPU sidecar: the package runtime has no HALOGEN_DOWNLOAD, so the files
    # from peonist-ai/halogen-npu-embeddinggemma-2 are pre-fetched into
    # ${modelDir}/npu/embeddinggemma-2 (/srv/halogen-models).
    # XRT (the entrypoint's hardcoded /opt/xilinx/xrt) comes from the
    # vendored xrt-amdxdna package, built from source.
    npu = {
      enable = true;
      models = [ "embeddinggemma-2" ];
      xrtPackage = self.packages.${pkgs.system}.xrt-amdxdna;
    };
  };
}
