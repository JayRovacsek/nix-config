{ lib, fetchFromGitHub, rustPlatform }:
let
  inherit (rustPlatform) buildRustPackage;
  pname = "action-validator";
  version = "0.5.4";

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
    hash = "sha256-roWmks+AgRf2ACoI7Vc/QEyqgQ0bR/XhRwLk9VaLEdY=";
  };

  cargoSha256 = "sha256-WUtFWuk2y/xXe39doMqANaIr0bbxmLDpT4/H2GRGH6k=";

in buildRustPackage { inherit pname version src meta cargoSha256; }
