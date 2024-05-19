{ lib, fetchFromGitHub, buildGoModule }:
let
  pname = "trdsql";
  version = "0.20.0";

  meta = with lib; {
    homepage = "https://github.com/noborus/trdsql";
    description =
      "CLI tool that can execute SQL queries on CSV, LTSV, JSON and TBLN.";
    license = licenses.mit;
  };

  src = fetchFromGitHub {
    owner = "noborus";
    repo = "trdsql";
    rev = "v${version}";
    hash = "sha256-dlLhnRRg7kkRjjcDfId1VoUE5tQdYmue+GavN08Czrc=";
  };

  vendorHash = "sha256-8wF06bIM+tDYqd8tyXKOehuYJQvyqhLBJv0K47vh8hY=";

  doCheck = false;

in buildGoModule { inherit pname version src meta vendorHash doCheck; }
