{ lib, fetchFromGitHub, python3Packages, ... }:
let
  pname = "faceswap";
  version = "0.0.1";

  meta = with lib; {
    description = "";
    platforms = platforms.all;
    homepage = "https://github.com/deepfakes/faceswap";
    license = licenses.asl20;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname version meta;

  src = fetchFromGitHub {
    owner = "deepfakes";
    repo = pname;
    rev = "a660eda8e1cdb513edc8d46adaed17bc8935e56a";
    sha256 = "sha256-caxPJvdCtgV4VLmxCiI2DSbKaa0100OAruBo95Q9344=";
  };

  doCheck = false;
}
