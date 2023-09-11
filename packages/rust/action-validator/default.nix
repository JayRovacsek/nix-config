{ lib, fetchFromGitHub, rustPlatform }:
let
  inherit (rustPlatform) buildRustPackage;
  pname = "action-validator";
  version = "0.5.3";

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
    hash = "sha256-22oYPYGnNp4K68pbNMolGcIGDYqjT/3FibO/jv3IEvg=";
  };

  cargoSha256 = "sha256-CVDqXuAxI1vCZV4w8DS3fOrsYFvJoI35fbe+hnSahLc=";

in buildRustPackage { inherit pname version src meta cargoSha256; }
