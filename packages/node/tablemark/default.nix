{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nodejs,
}:
let
  pname = "haltcase";
  version = "3.1.0";

  meta = with lib; {
    homepage = "https://github.com/haltcase/tablemark";
    description = "Generate markdown tables from JSON data";
    license = licenses.mit;
  };

  src = fetchFromGitHub {
    owner = "haltcase";
    repo = "tablemark";
    hash = "sha256-wcWWtGbUPvwdiKt6ukr725x+dDr8lp+rc8EKs68t13w=";
    rev = "v${version}";
  };

  npmDepsHash = "sha256-OMw3bwprY1qDU1/6cCi4FlcSEKnqrVDYlh62pWx3a9k=";

  patches = [ ./add-lockfile.patch ];

  dontNpmPrune = true;

in
buildNpmPackage {
  inherit
    pname
    version
    patches
    dontNpmPrune
    src
    meta
    nodejs
    npmDepsHash
    ;
}
