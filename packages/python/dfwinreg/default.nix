{ pkgs, lib, fetchPypi, python3Packages, self, ... }:
let
  inherit (pkgs) system;

  pname = "dfwinreg";

  version = "20240229";

  meta = with lib; {
    description =
      "dfWinReg, or Digital Forensics Windows Registry, provides read-only access to Windows Registry objects. The goal of dfWinReg is to provide a generic interface for accessing Windows Registry objects that resembles the Registry key hierarchy as seen on a live Windows system.";
    platforms = platforms.all;
    homepage = "https://github.com/log2timeline/dfwinreg";
    downloadPage = "https://github.com/log2timeline/dfwinreg/releases";
    license = licenses.asl20;
  };

  inherit (python3Packages) buildPythonPackage pyyaml setuptools;

  inherit (self.packages.${system})
    dfdatetime libregf-python libcreg-python dtfabric;

in buildPythonPackage {
  inherit pname version meta;

  nativeBuildInputs = [ setuptools ];
  propagatedBuildInputs =
    [ dfdatetime libregf-python libcreg-python pyyaml dtfabric ];
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-guiWjSx3LsPkPOgqN6axfE36FOuZet5LrnYIHZqQ6WM=";
  };
}
