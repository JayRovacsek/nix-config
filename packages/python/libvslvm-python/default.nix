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
  pname = "libvslvm-python";
  version = "20260901";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/libyal/libvslvm/releases/download/20260901/libvslvm-experimental-20260901.tar.gz";
    hash = "sha256-n9B44yqfjZNAnIRscyFE4WP0VAto/z5FYIDCqgVmcLs=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools wheel ];

  disabled = pythonOlder "3.10";

  pythonImportsCheck = [ "pyvslvm" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libvslvm";
    downloadPage = "https://github.com/libyal/libvslvm/releases";
    homepage = "https://github.com/libyal/libvslvm";
    license = licenses.lgpl3Plus;
  };
}
