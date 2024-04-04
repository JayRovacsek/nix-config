{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libbde-python";

  version = "20240223";

  meta = with lib; {
    description =
      "ACStore, or Attribute Container Storage, provides a stand-alone implementation to read and write attribute container storage files.";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libbde/";
    downloadPage = "https://github.com/libyal/libbde/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage setuptools;

in buildPythonPackage {
  inherit pname version meta;

  nativeBuildInputs = [ setuptools ];
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6Au2V4rZ1YAa4gumZXbiWs0DeJQbEM9oJJVjsjJCiYA=";
  };
}
