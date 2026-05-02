{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
    loadModels = [ ];
    # TODO: add logic to check for presence of nivida
    package = pkgs.ollama;
  };
}
