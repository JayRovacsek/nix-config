{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "libfsntfs-python";
  name = pname;
  version = "20231125";

  meta = with lib; {
    description = "Python bindings module for libfsntfs";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libfsntfs/";
    downloadPage = "https://github.com/libyal/libfsntfs/releases";
    license = licenses.lgpl3Plus;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4jxemTiozAuneNvrsb4pouO4Sh4W2dTO+jyzdgizIK0=";
  };

  doCheck = false;
}
