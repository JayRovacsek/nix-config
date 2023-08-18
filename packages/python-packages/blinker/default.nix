{ lib, python, ... }:
let inherit (python) buildPythonPackage fetchPypi pytestCheckHook setuptools;
in buildPythonPackage rec {
  pname = "blinker";
  version = "1.6.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Sv095m7zqfgGdVn7ehy+VVwX3L4VlxsF0bYlw+er4hM=";
  };

  propagatedBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook setuptools ];

  pythonImportsCheck = [ "blinker" ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://pythonhosted.org/blinker/";
    description = "Fast, simple object-to-object and broadcast signaling";
    license = licenses.mit;
  };
}
