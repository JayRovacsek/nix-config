{ lib, fetchFromGitHub, buildGoModule }:
let
  pname = "trdsql";
  version = "0.13.0";

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
    sha256 = "sha256-h7vUwZlk27ZD8RzNplxCJ3h7FxEKAHQS73gYrDq0Wfc=";
  };

  vendorHash = "sha256-D6LrpWMebBoz1chhXSkpRRyU2o6HbnXU9UkdnHjUS6k=";

in buildGoModule { inherit pname version src meta vendorHash; }
