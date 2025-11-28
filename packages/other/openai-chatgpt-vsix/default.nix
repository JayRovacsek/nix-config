{ pkgs, ... }:
pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "chatgpt";
    publisher = "openai";
    version = "0.1.1741291060";
    hash = "sha256-N5MJKY0DTLCLHPaVB/k6o1j8ev7Z4VNOfYC6NU9g9RE=";
  };
}
