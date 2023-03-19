{ self, system, lib, stdenv, fetchPypi, python }:
let
  pname = "libfsfat-python";
  name = pname;
  version = "20220925";

  meta = with lib; {
    description = "Python bindings module for libfsfat";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libfsfat/";
    downloadPage = "https://github.com/libyal/libfsfat/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python) buildPythonPackage pip;

in buildPythonPackage {
  inherit pname name version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-dv1pGbNO73xogXrmon1swmjNu5ICEIKKx/D3uWdNNp4=";
  };

  doCheck = false;
}
