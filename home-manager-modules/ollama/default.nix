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

  home.file.".continue/config.yaml".source =
    pkgs.writers.writeYAML "config.yaml"
      {
        name = "Local Config";
        version = "1.0.0";
        schema = "v1";
        inherit (config.services.ollama) models;
      };

  programs.vscode.profiles.default.extensions =
    lib.mkIf config.programs.vscode.enable
      [
        pkgs.vscode-extensions.continue.continue
      ];

  services.ollama = {
    enable = true;
    package = pkgs.ollama-cpu;
    models = [
      {
        name = "nomic-embed-text";
        model = "nomic-embed-text";
        roles = [ "embed" ];
      }
      {
        name = "devstral-small-2";
        model = "devstral-small-2";
        roles = [
          "autocomplete"
          "chat"
          "edit"
          "rerank"
        ];
      }
    ];
  };
}
