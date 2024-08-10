{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
let
  pname = "pdscan";
  version = "0.1.8";

  meta = with lib; {
    homepage = "https://github.com/ankane/pdscan";
    description = "Scan your data stores for unencrypted personal data (PII)";
    license = licenses.mit;
  };

  src = fetchFromGitHub {
    owner = "ankane";
    repo = "pdscan";
    rev = "v${version}";
    hash = "sha256-F4owE2IFj9r/HcmFQ/63HlE15xrhdGe/aU6anSnPmWM=";
  };

  vendorHash = "sha256-Dx4zjVMgKye5vYoinX6CnQdSCQ+8Ryd2i3ToHlnBjcI=";

  doCheck = false;

in
buildGoModule {
  inherit
    pname
    version
    src
    meta
    vendorHash
    doCheck
    ;
}
