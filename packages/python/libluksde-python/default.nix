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
  pname = "libluksde-python";
  version = "20260902";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/libyal/libluksde/releases/download/20260902/libluksde-experimental-20260902.tar.gz";
    hash = "sha256-IVH//dNaqG07btVWDA5VGUSDeEO4fMC44FGoVyMa2AA=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools wheel ];

  disabled = pythonOlder "3.10";

  pythonImportsCheck = [ "pyluksde" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libluksde";
    downloadPage = "https://github.com/libyal/libluksde/releases";
    homepage = "https://github.com/libyal/libluksde";
    license = licenses.lgpl3Plus;
  };
}
