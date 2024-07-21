_: {
  services.ollama = {
    enable = true;
    acceleration = "cuda";
    loadModels = [ "phi3:3.8b" ];
  };
}
