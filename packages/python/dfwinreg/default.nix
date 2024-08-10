{
  pkgs,
  lib,
  fetchPypi,
  python3Packages,
  self,
  ...
}:
let
  inherit (pkgs) system;

  inherit (python3Packages) buildPythonPackage pyyaml setuptools;

  inherit (self.packages.${system})
    dfdatetime
    libregf-python
    libcreg-python
    dtfabric
    ;

in
buildPythonPackage rec {
  pname = "dfwinreg";
  version = "20240229";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-guiWjSx3LsPkPOgqN6axfE36FOuZet5LrnYIHZqQ6WM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    dfdatetime
    libregf-python
    libcreg-python
    pyyaml
    dtfabric
  ];

  pythonImportsCheck = [ pname ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "dfWinReg, or Digital Forensics Windows Registry, provides read-only access to Windows Registry objects. The goal of dfWinReg is to provide a generic interface for accessing Windows Registry objects that resembles the Registry key hierarchy as seen on a live Windows system.";
    downloadPage = "https://github.com/log2timeline/dfwinreg/releases";
    homepage = "https://github.com/log2timeline/dfwinreg";
    license = licenses.asl20;
  };
}
