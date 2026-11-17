{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
let
  pname = "trdsql";
  version = "1.2.3";

  meta = with lib; {
    homepage = "https://github.com/noborus/trdsql";
    description = "CLI tool that can execute SQL queries on CSV, LTSV, JSON and TBLN.";
    license = licenses.mit;
  };

  src = fetchFromGitHub {
    owner = "noborus";
    repo = "trdsql";
    rev = "v${version}";
    hash = "sha256-lYBdroPg0Z+7p4akwBV3ey9S3s1uemQMfkyfZC8xeGQ=";
  };

  vendorHash = "sha256-1s2fQue0mLhJ9dKILrERa21Ut05/zVCwL2txZlqcCqE=";

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
