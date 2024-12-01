{
  lib,
  zlib,
  fetchPypi,
  python3Packages,
  ...
}:
let
  inherit (python3Packages) buildPythonPackage setuptools;
in
buildPythonPackage rec {
  pname = "libmodi-python";
  version = "20240507";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9YOXSTaJwl3cVdCacze0idNfoad88UCtojXJ3PZ6pC0=";
  };

  build-system = [ setuptools ];

  buildInputs = [ zlib ];

  pythonImportsCheck = [ "pymodi" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libmodi";
    downloadPage = "https://github.com/libyal/libmodi/releases";
    homepage = "https://github.com/libyal/libmodi";
    license = licenses.lgpl3Plus;
  };
}
