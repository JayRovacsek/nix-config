{
  pkgs,
  ...
}:
pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "twinny";
    publisher = "rjmacarthy";
    version = "4.2.7";
    hash = "sha256-/dkcG2gE/v45yPlsu0EJCMo1SGOT1VF9NOfnjYfrFKQ=";
  };
}
