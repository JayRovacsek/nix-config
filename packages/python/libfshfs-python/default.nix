{ lib, zlib, fetchPypi, python3Packages, ... }:
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

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  buildInputs = [ zlib ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vKZapQz/xK/YrvZ4+rMCdId8j/6EjiBnM4AMwD1E108=";
  };

  doCheck = false;
}
