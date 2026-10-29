_: {
  imports = [ ../../options/modules/halogen-flash-server ];

  services.halogen-flash-server = {
    enable = true;
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
  };
}
