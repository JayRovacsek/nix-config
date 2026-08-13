{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (pkgs) system;
in
{
  programs.vscode = lib.mkIf config.programs.vscode.enable {
    profiles.default = {
      extensions = with self.packages.${system}; [ dbt-vsix ];

      userSettings = {
        "dbt.beta.useQueryCache" = true;
        "dbt.lspPath" = ".vscode/bin/dbt-lsp";
        "dbt.dbtPath" = ".vscode/bin/dbt";
      };
    };
  };
}
