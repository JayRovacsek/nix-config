{ self, system, lib, stdenv, fetchurl, fetchPypi, gnutar, python310Packages }:
let
  pname = "plaso";
  name = pname;
  version = "20230311";
  meta = with lib; {
    description =
      "Plaso (Plaso Langar Að Safna Öllu), or super timeline all the things, is a Python-based engine used by several tools for automatic creation of timelines. Plaso default behavior is to create super timelines but it also supports creating more targeted timelines.";
    platforms = platforms.all;
    homepage = "https://github.com/log2timeline/plaso";
    downloadPage = "https://github.com/log2timeline/plaso/releases";
    license = licenses.asl20;
  };

  inherit (python310Packages)
    buildPythonPackage pip pyyaml XlsxWriter cffi redis bencode-py pytz
    opensearch-py psutil yara-python;

  inherit (self.packages.${system}.python310Packages)
    acstore libbde-python libfwnt-python dfdatetime libfsxfs-python
    libluksde-python libfshfs-python liblnk-python libqcow-python dfwinreg
    libregf-python flor;

in buildPythonPackage {
  inherit pname name version;
  nativeBuildInputs = [ ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-hruwIXFfKiIBG/oEjOHGQbhzJVIRNmdVcGAHitxidWQ=";
  };

  doCheck = false;

  propagatedBuildInputs = [
    acstore
    bencode-py
    cffi
    dfdatetime
    dfwinreg
    libbde-python
    libfshfs-python
    libfsxfs-python
    libfwnt-python
    liblnk-python
    libluksde-python
    libqcow-python
    libregf-python
    opensearch-py
    pip
    psutil
    pytz
    pyyaml
    redis
    XlsxWriter
    yara-python
    flor
  ];
}
