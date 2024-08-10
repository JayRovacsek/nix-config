{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
    acceleration = "cuda";
    loadModels = [ ];
    # TODO: add logic to check for presence of nivida 
    package = pkgs.ollama-cuda;
  };
}
