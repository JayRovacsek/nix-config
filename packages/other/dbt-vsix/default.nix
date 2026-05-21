{ pkgs, ... }:
pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "dbt";
    publisher = "dbtLabsInc";
    version = "0.73.0";
    hash = "sha256-LiEc09GmE44RlJ+GwCn4cgIymcaBKoACHBUajfJ7Q8s=";
  };
}
