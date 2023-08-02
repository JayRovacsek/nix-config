{ vscode-utils }:
let
  pname = "codeium";
  name = pname;
  version = "1.2.55";
  sha256 = "sha256:06dw4g8if3ad2v6fp1003826ardajqi5bfnlpmisa7vradw9l4gx";
  publisher = "Codeium";

  vsix = builtins.fetchurl {
    inherit sha256;
    url =
      "https://open-vsx.org/api/${publisher}/${name}/${version}/file/${publisher}.${name}-${version}.vsix";
    name = "${publisher}-${name}.zip";
  };

in vscode-utils.extensionFromVscodeMarketplace {
  inherit name publisher version vsix;
}
