{ self, system, lib, stdenv, zlib, fetchPypi, python }:
let
  pname = "libfshfs-python";
  name = pname;
  version = "20220831";

  meta = with lib; {
    description = "Python bindings module for libfshfs";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libfshfs/";
    downloadPage = "https://github.com/libyal/libfshfs/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version;

  buildInputs = [ zlib ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vKZapQz/xK/YrvZ4+rMCdId8j/6EjiBnM4AMwD1E108=";
  };

  doCheck = false;
}
