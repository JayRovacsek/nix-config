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
    bencode-py buildPythonPackage certifi cffi cryptography defusedxml future
    lz4 opensearch-py pefile pip psutil pyparsing python-dateutil pytz pyxattr
    pyyaml pyzmq redis requests XlsxWriter yara-python six;

  inherit (self.packages.${system}.python310Packages)
    acstore artifacts dfdatetime dfvfs dfwinreg flor libbde-python
    libesedb-python libevtx-python libewf-python libfsapfs-python
    libfshfs-python libfsxfs-python libfwnt-python liblnk-python
    libluksde-python libmodi-python libphdi-python libqcow-python libregf-python
    libscca-python libsigscan-python libsmdev-python libvhdi-python
    libvsgpt-python libfwsi-python libcreg-python libmsiecf-python
    libfsext-python libfsfat-python libfsntfs-python libfvde-python
    libolecf-python libsmraw-python libvmdk-python libvshadow-python
    libevt-python libvslvm-python pytsk3;

in buildPythonPackage {
  inherit pname name version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-hruwIXFfKiIBG/oEjOHGQbhzJVIRNmdVcGAHitxidWQ=";
  };

  doCheck = false;

  propagatedBuildInputs = [
    acstore
    artifacts
    bencode-py
    certifi
    cffi
    cryptography
    defusedxml
    dfdatetime
    dfvfs
    dfwinreg
    flor
    future
    libbde-python
    libesedb-python
    libevtx-python
    libewf-python
    libfsapfs-python
    libfshfs-python
    libfsxfs-python
    libfwnt-python
    liblnk-python
    libluksde-python
    libmodi-python
    libphdi-python
    libqcow-python
    libregf-python
    libscca-python
    libsigscan-python
    libsmdev-python
    pytsk3
    libvhdi-python
    libvsgpt-python
    lz4
    libevt-python
    libvslvm-python
    libsmraw-python
    opensearch-py
    libvshadow-python
    pefile
    pip
    psutil
    pyparsing
    python-dateutil
    pytz
    pyxattr
    pyyaml
    pyzmq
    redis
    requests
    XlsxWriter
    yara-python
    libfwsi-python
    six
    libcreg-python
    libmsiecf-python
    libfsext-python
    libfsfat-python
    libfsntfs-python
    libfvde-python
    libolecf-python
    libvmdk-python
  ];
}
