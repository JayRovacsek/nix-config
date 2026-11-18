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
  pname = "libfsntfs-python";
  version = "20260827";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/libyal/libfsntfs/releases/download/20260827/libfsntfs-experimental-20260827.tar.gz";
    hash = "sha256-cvRu03TF5hvyS/hA7tEIafWToNHZEj0HIS0Oszam7tc=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools wheel ];

  disabled = pythonOlder "3.10";

  pythonImportsCheck = [ "pyfsntfs" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libfsntfs";
    downloadPage = "https://github.com/libyal/libfsntfs/releases";
    homepage = "https://github.com/libyal/libfsntfs";
    license = licenses.lgpl3Plus;
  };
}
