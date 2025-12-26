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

  programs.vscode.profiles.default = {
    extensions = lib.mkIf config.programs.vscode.enable [
      pkgs.vscode-extensions.continue.continue
    ];
    userSettings."yaml.schemas"."file://${config.home.homeDirectory}/.vscode-oss/extensions/Continue.continue/config-yaml-schema.json" =
      [
        ".continue/**/*.yaml"
      ];
  };

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
        name = "gemma3:4b";
        model = "gemma3:4b";
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
