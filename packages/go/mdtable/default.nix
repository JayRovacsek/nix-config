{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
let
  pname = "mdtable";
  version = "1.0.0";

  meta = with lib; {
    homepage = "https://github.com/moul/mdtable";
    description = "csv/json to markdown tables with customizable format";
    license = licenses.mit;
  };

  src = fetchFromGitHub {
    owner = "moul";
    repo = "mdtable";
    rev = "v${version}";
    hash = "sha256-VMd3XcjX1rNZe8saL3bDoBKNB3fSy9hIe51YpYqI+8s=";
  };

  vendorHash = "sha256-i/cHxRAIVjlpCIfVouESsqPALdUxbtgHTJt6n853fnw=";
in
buildGoModule {
  inherit
    pname
    version
    src
    meta
    vendorHash
    ;
}
