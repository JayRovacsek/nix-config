# https://nixos.wiki/wiki/Packaging/Binaries
{ pkgs, lib, stdenv, fetchFromGitHub, buildGoModule }:
let
  pname = "trdsql";
  version = "0.11.1";

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
    sha256 = "sha256-6y0mBMGCM/NisdTk9OIM6kFtdADSlWGwBK34nbZL33c=";
  };

  vendorHash = "sha256-22zbnyS0+ae1W766Wdog05TOBfY35Ypu20nTSWJ7/cg=";

in buildGoModule { inherit pname version src meta vendorHash; }
