_: {
  services.llama-cpp = {
    enable = true;
    modelsDir = "/srv/storage/models";
    openFirewall = true;
    host = "0.0.0.0";
    modelsPreset = {
      # gemma-4-E2B = {
      #   hf-repo = "unsloth/gemma-4-E2B-it-GGUF";
      #   hf-file = "gemma-4-E2B-it-UD-Q5_K_XL.gguf";
      #   alias = "unsloth/gemma-4-E2B-it-GGUF";
      #   fit = "on";
      #   seed = "3407";
      #   temp = "1.0";
      #   top-p = "0.95";
      #   min-p = "0.01";
      #   top-k = "40";
      #   jinja = "on";
      # };
      gemma-4-E4B = {
        hf-repo = "unsloth/gemma-4-E4B-it-GGUF";
        hf-file = "gemma-4-E4B-it-UD-Q5_K_XL.gguf";
        alias = "unsloth/gemma-4-E4B-it-GGUF";
        fit = "on";
        temp = "1.0";
        top-p = "0.95";
        min-p = "0.01";
        top-k = "40";
        jinja = "on";
      };
      # gemma-4-31B = {
      #   hf-repo = "unsloth/gemma-4-31B-it-GGUF:UD-IQ2_XXS";
      #   hf-file = "gemma-4-31B-it-UD-IQ2_XXS.gguf";
      #   alias = "unsloth/gemma-4-31B-it-GGUF";
      #   fit = "on";
      #   temp = "1.0";
      #   top-p = "0.95";
      #   min-p = "0.01";
      #   top-k = "64";
      #   jinja = "on";
      # };
    };

    extraFlags = [

      # Router server: limit concurrent loaded models to save VRAM
      "--models-max"
      "1" # Load 1 model at a time, auto-swap on demand

      # Enable automatic model loading/unloading based on requests
      "--models-autoload"

      # ── Context window ────────────────────────────────────────────────
      # 131072 = 128k tokens.
      "-c"
      "131072"

      # ── Idle model unload ─────────────────────────────────────────────
      # Unload model weights from GPU VRAM after 3h of no requests.
      "--sleep-idle-seconds"
      "10800" # 3h

      # ── API ───────────────────────────────────────────────────────────
      "--jinja" # enable jinja2 chat template support

      # Enable reasoning/thinking mode
      "--reasoning"
      "on"

      # ── Concurrency ───────────────────────────────────────────────────
      # Number of parallel request slots. 1 = sequential (safest for VRAM).
      "--parallel"
      "1"
    ];
  };
}
