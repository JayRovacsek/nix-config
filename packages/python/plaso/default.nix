{ pkgs, lib, fetchPypi, python3Packages, self, ... }:
let
  inherit (pkgs) system;

  pname = "plaso";
  name = pname;
  version = "20230717";
  meta = with lib; {
    description =
      "Plaso (Plaso Langar Að Safna Öllu), or super timeline all the things, is a Python-based engine used by several tools for automatic creation of timelines. Plaso default behavior is to create super timelines but it also supports creating more targeted timelines.";
    platforms = platforms.all;
    homepage = "https://github.com/log2timeline/plaso";
    downloadPage = "https://github.com/log2timeline/plaso/releases";
    license = licenses.asl20;
  };

  inherit (python3Packages)
    bencode-py buildPythonPackage certifi cffi cryptography defusedxml future
    lz4 opensearch-py pefile pip psutil pyparsing python-dateutil pytz pyyaml
    pyzmq pyxattr redis requests six XlsxWriter yara-python;

  inherit (self.packages.${system})
    acstore artifacts dfdatetime dfvfs dfwinreg flor libbde-python
    libcreg-python libesedb-python libevt-python libevtx-python libewf-python
    libfsapfs-python libfsext-python libfsfat-python libfshfs-python
    libfsntfs-python libfsxfs-python libfvde-python libfwnt-python
    libfwsi-python liblnk-python libluksde-python libmodi-python
    libmsiecf-python libolecf-python libphdi-python libqcow-python
    libregf-python libscca-python libsigscan-python libsmdev-python
    libsmraw-python libvhdi-python libvmdk-python libvsgpt-python
    libvshadow-python libvslvm-python pytsk3;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Ao8A6r1OeCS6s/5ZJRiooJXNylsgTCh5Kqz98eNImmQ=";
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
    libcreg-python
    libesedb-python
    libevt-python
    libevtx-python
    libewf-python
    libfsapfs-python
    libfsext-python
    libfsfat-python
    libfshfs-python
    libfsntfs-python
    libfsxfs-python
    libfvde-python
    libfwnt-python
    libfwsi-python
    liblnk-python
    libluksde-python
    libmodi-python
    libmsiecf-python
    libolecf-python
    libphdi-python
    libqcow-python
    libregf-python
    libscca-python
    libsigscan-python
    libsmdev-python
    libsmraw-python
    libvhdi-python
    libvmdk-python
    libvsgpt-python
    libvshadow-python
    libvslvm-python
    lz4
    opensearch-py
    pefile
    pip
    psutil
    pyparsing
    python-dateutil
    pytsk3
    pytz
    pyxattr
    pyyaml
    pyzmq
    redis
    requests
    six
    XlsxWriter
    yara-python
  ];
}
