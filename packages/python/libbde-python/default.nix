{
  lib,
  fetchurl,
  pkg-config,
  python3Packages,
  ...
}:
let
  inherit (python3Packages) buildPythonPackage pythonOlder setuptools wheel;
in
buildPythonPackage rec {
  pname = "libbde-python";
  version = "20260916";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/libyal/libbde/releases/download/20260916/libbde-alpha-20260916.tar.gz";
    hash = "sha256-IqJ8gffopRMjXBjWQoibaQ/v00ql7mh5KRA75iJG2mg=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools wheel ];

  disabled = pythonOlder "3.10";

  pythonImportsCheck = [ "pybde" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "ACStore, or Attribute Container Storage, provides a stand-alone implementation to read and write attribute container storage files.";
    downloadPage = "https://github.com/libyal/libbde/releases";
    homepage = "https://github.com/libyal/libbde";
    license = licenses.lgpl3Plus;
  };
}
