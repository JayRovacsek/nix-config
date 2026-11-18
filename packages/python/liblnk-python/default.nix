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
  pname = "liblnk-python";
  version = "20260525";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/libyal/liblnk/releases/download/20260525/liblnk-alpha-20260525.tar.gz";
    hash = "sha256-czxjkmrNNcyaqQ961xIpjPII7glLAJswdSw6usK5LzY=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools wheel ];

  disabled = pythonOlder "3.10";

  pythonImportsCheck = [ "pylnk" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for liblnk";
    downloadPage = "https://github.com/libyal/liblnk/releases";
    homepage = "https://github.com/libyal/liblnk";
    license = licenses.lgpl3Plus;
  };
}
