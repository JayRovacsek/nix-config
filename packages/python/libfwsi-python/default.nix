{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libfwsi-python";
  name = pname;
  version = "20231130";

  meta = with lib; {
    description = "Python bindings module for libfwsi";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libfwsi/";
    downloadPage = "https://github.com/libyal/libfwsi/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RwJF1ufPDQNZT3AvAULgftWfDC8Wx2OmKex7CpJ5UiU=";
  };

  doCheck = false;
}
