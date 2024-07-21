{ pkgs, ... }: {
  services.ollama = {
    enable = true;
    acceleration = "cuda";
    loadModels = [ "phi3:3.8b" ];
    # TODO: add logic to check for presence of nivida 
    package = pkgs.ollama-cuda;
  };
}
