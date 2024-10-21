{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../../options/home-manager-modules/ollama
  ];

  programs.vscode.extensions = lib.mkIf config.programs.vscode.enable [
    pkgs.vscode-extensions.continue.continue
  ];

  services.ollama = {
    enable = true;
    models = [ "deepseek-coder-v2" ];
  };
}
