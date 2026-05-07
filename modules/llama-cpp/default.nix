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
        hf-file = "gemma-4-E4B-it-UD-Q8_K_XL.gguf";
        alias = "gemma-4-E4B-it-GGUF";
        fit = "on";
        temp = "1.0";
        top-p = "0.95";
        min-p = "0.01";
        top-k = "40";
        jinja = "on";
      };

      # "deepseek-r1-8b" = {
      #   hf-repo = "unsloth/DeepSeek-R1-0528-Qwen3-8B-GGUF";
      #   hf-file = "DeepSeek-R1-0528-Qwen3-8B-Q8_0.gguf";
      #   alias = "unsloth/DeepSeek-R1-0528-Qwen3-8B";
      #   fit = "on";
      #   temp = "0.6";
      #   top-p = "0.95";
      #   jinja = "on";
      # };

      "qwen3.6-35b-a3b" = {
        hf-repo = "unsloth/Qwen3.6-35B-A3B-GGUF";
        hf-file = "Qwen3.6-35B-A3B-UD-IQ2_XXS.gguf";
        alias = "unsloth/Qwen3-Coder-30B-A3B";
        fit = "on";
        temp = "0.6";
        top-p = "0.8";
        top-k = "20";
        min-p = "0.0";
        jinja = "on";
      };

      # "qwen3-coder-30b-a3b" = {
      #   hf-repo = "unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF";
      #   hf-file = "Qwen3-Coder-30B-A3B-Instruct-UD-IQ2_XXS.gguf";
      #   alias = "unsloth/Qwen3-Coder-30B-A3B";
      #   fit = "on";
      #   temp = "0.7";
      #   top-p = "0.8";
      #   top-k = "20";
      #   jinja = "on";
      # };

      # gemma-4-31B = {
      #   hf-repo = "unsloth/gemma-4-31B-it-GGUF:UD-IQ2_XXS";
      #   hf-file = "gemma-4-31B-it-UD-IQ2_XXS.gguf";
      #   alias = "unsloth/gemma-4-31B-it-GGUF";
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
      # 262144 = 256k tokens.
      "-c"
      "262144"

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

      "--cache-type-k"
      "q4_0" # quantised KV cache (Q4_0) to save VRAM
      "--cache-type-v"
      "q4_0" # quantised KV cache (Q4_0) to save VRAM

      "--n-gpu-layers"
      "999" # offload all layers to GPU

      "--no-mmap" # avoid memory mapping to save host RAM
      "--mlock" # lock memory into RAM to avoid swapping
    ];
  };
}
