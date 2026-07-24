{ pkgs, ... }:
pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "llama-vscode";
    publisher = "ggml-org";
    version = "0.0.47";
    hash = "sha256-bEYGm38pFq5kK5HFCmn0OMFutPUzqprelBrwVHcdImA=";
  };
}
