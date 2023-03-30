{ self, system, lib, stdenv, fetchPypi, python }:
let
  pname = "pyxattr";
  name = pname;
  version = "0.8.0";

  meta = with lib; {
    description = ''
      This is a C extension module for Python which implements extended attributes manipulation. It is a wrapper on top of the attr C library - see attr(5).
    '';
    platforms = platforms.all;
    homepage = "https://pyxattr.k1024.org/";
    downloadPage = "https://pyxattr.k1024.org/downloads/";
    license = licenses.lgpl2Plus;
  };

  inherit (python) buildPythonPackage pip;

in buildPythonPackage {
  inherit pname name version;

  hardeningDisable = lib.optionals stdenv.isDarwin [ "strictoverflow" ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-e/QM7FrpPdZWEocX29Joz8Ozso2VU214hndslPomeFU=";
  };

  doCheck = false;
}
