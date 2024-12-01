{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
let
  pname = "trdsql";
  version = "1.1.0";

  meta = with lib; {
    homepage = "https://github.com/noborus/trdsql";
    description = "CLI tool that can execute SQL queries on CSV, LTSV, JSON and TBLN.";
    license = licenses.mit;
  };

  src = fetchFromGitHub {
    owner = "noborus";
    repo = "trdsql";
    rev = "v${version}";
    hash = "sha256-MkjQAOIXnydEmOFnnYrvE2TF2I0GqSrSRUAjd+/hHwc=";
  };

  vendorHash = "sha256-PoIa58vdDPYGL9mjEeudRYqPfvvr3W+fX5c+NgRIoLg=";

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
