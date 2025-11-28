{ pkgs, ... }:
pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "dbt";
    publisher = "dbtLabsInc";
    version = "0.23.3";
    hash = "sha256-NJwCikke6ixfFT+Vttkl8H5l+AxBq7rnzci42En9RBw=";
  };
}
