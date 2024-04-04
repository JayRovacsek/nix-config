{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libfwsi-python";

  version = "20240315";

  meta = with lib; {
    description = "Python bindings module for libfwsi";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libfwsi/";
    downloadPage = "https://github.com/libyal/libfwsi/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage setuptools;

in buildPythonPackage {
  inherit pname version meta;

  nativeBuildInputs = [ setuptools ];
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-FmtU0apa9kfwTqCJbpBL+NVHFCN3BtMXAWtY71MZsgg=";
  };
}
