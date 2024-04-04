{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libfsxfs-python";

  version = "20231124";

  meta = with lib; {
    description = "Python bindings module for libfsxfs";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libfsxfs/";
    downloadPage = "https://github.com/libyal/libfsxfs/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage setuptools;

in buildPythonPackage {
  inherit pname version meta;

  nativeBuildInputs = [ setuptools ];
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-h8Cn/0rI7tYYxKgX2pt9/96f9XOiGiOk9gI9i+KeLxc=";
  };
}
