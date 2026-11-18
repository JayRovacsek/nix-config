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
  pname = "libvshadow-python";
  version = "20260714";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/libyal/libvshadow/releases/download/20260714/libvshadow-alpha-20260714.tar.gz";
    hash = "sha256-floET4kAl76MQB2R72EyLDH+OOPB/TrglzF01sdWm9A=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [ setuptools wheel ];

  disabled = pythonOlder "3.10";

  pythonImportsCheck = [ "pyvshadow" ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "Python bindings module for libvshadow";
    downloadPage = "https://github.com/libyal/libvshadow/releases";
    homepage = "https://github.com/libyal/libvshadow";
    license = licenses.lgpl3Plus;
  };
}
