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
  home.packages = [
    pkgs.dbt
  ];

  programs.vscode = lib.mkIf config.programs.vscode.enable {
    profiles.default = {
      extensions = with self.packages.${system}; [ dbt-vsix ];

      userSettings = {
        "dbt.beta.useQueryCache" = true;
      };
    };
  };
}
