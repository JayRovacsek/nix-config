{ pkgs, lib, fetchPypi, python3Packages, self, ... }:
let
  inherit (pkgs) system;

  pname = "dfwinreg";
  name = pname;
  version = "20221218";

  meta = with lib; {
    description =
      "dfWinReg, or Digital Forensics Windows Registry, provides read-only access to Windows Registry objects. The goal of dfWinReg is to provide a generic interface for accessing Windows Registry objects that resembles the Registry key hierarchy as seen on a live Windows system.";
    platforms = platforms.all;
    homepage = "https://github.com/log2timeline/dfwinreg";
    downloadPage = "https://github.com/log2timeline/dfwinreg/releases";
    license = licenses.asl20;
  };

  inherit (python3Packages) buildPythonPackage pyyaml;

  inherit (self.packages.${system})
    dfdatetime libregf-python libcreg-python dtfabric;
in buildPythonPackage {
  inherit pname name version meta;
  propagatedBuildInputs =
    [ dfdatetime libregf-python libcreg-python pyyaml dtfabric ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qY49wRXGuK86lE12pJz17AxbKg+oAD2sXXy8eLS3LS0=";
  };

  doCheck = false;
}
