{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
let
  inherit (rustPlatform) buildRustPackage;
  pname = "action-validator";
  version = "0.6.0";

  meta = with lib; {
    homepage = "https://github.com/mpalmer/action-validator";
    description = "Tool to validate GitHub Action and Workflow YAML files";
    license = licenses.lgpl3Plus;
  };

  src = fetchFromGitHub {
    owner = "mpalmer";
    repo = "action-validator";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-lJHGx/GFddIwVVXRj75Z/l5CH/yuw/uIhr02Qkjruww=";
  };

  cargoSha256 = "sha256-mBY+J6JcIhV++tO6Dhw5JvYLSwoYZR3lB3l0KTjkcQM=";

in
buildRustPackage {
  inherit
    pname
    version
    src
    meta
    cargoSha256
    ;
}
