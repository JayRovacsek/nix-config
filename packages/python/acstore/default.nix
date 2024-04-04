{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "acstore";

  version = "20240128";

  meta = with lib; {
    description =
      "ACStore, or Attribute Container Storage, provides a stand-alone implementation to read and write attribute container storage files.";
    platforms = platforms.all;
    homepage = "https://github.com/log2timeline/acstore";
    downloadPage = "https://github.com/log2timeline/acstore/releases";
    license = licenses.asl20;
  };

  inherit (python3Packages) buildPythonPackage setuptools pyyaml;

in buildPythonPackage {
  inherit pname version meta;

  nativeBuildInputs = [ setuptools ];
  propagatedBuildInputs = [ pyyaml ];
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8phz/rUT+ppJPBGmnYn4WEKpjTOc/ENp3hkLAZALz9A=";
  };
}
