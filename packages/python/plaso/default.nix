{ pkgs, lib, fetchPypi, python3Packages, self, stdenv, ... }:
let
  inherit (pkgs) system;

  inherit (python3Packages)
    bencode-py buildPythonPackage certifi cffi defusedxml future lz4
    opensearch-py pefile pip psutil pyparsing python-dateutil pytz pyxattr
    pyyaml pyzmq redis requests setuptools six XlsxWriter yara-python zstd;

  inherit (self.packages.${system})
    acstore artifacts dfdatetime dfvfs dfwinreg flor libbde-python
    libcaes-python libcreg-python libesedb-python libevt-python libevtx-python
    libewf-python libfcrypto-python libfsapfs-python libfsext-python
    libfsfat-python libfshfs-python libfsntfs-python libfsxfs-python
    libfvde-python libfwnt-python libfwsi-python liblnk-python libluksde-python
    libmodi-python libmsiecf-python libolecf-python libphdi-python
    libqcow-python libregf-python libscca-python libsigscan-python
    libsmdev-python libsmraw-python libvhdi-python libvmdk-python
    libvsgpt-python libvshadow-python libvslvm-python pytsk3;

in buildPythonPackage rec {
  pname = "plaso";
  version = "20240308";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pRYppmsIRBJHlPipM7cLpvWqLNJ5QiX9+/thI83/Gvc=";
  };

  build-system = [ setuptools ];

  # This is required only as the build process incorrectly assumes xattr
  # is not installed, despite it being included in dependencies.
  patches = [ ./no-xattr-dependency.patch ];

  dependencies = [
    acstore
    artifacts
    bencode-py
    certifi
    cffi
    defusedxml
    dfdatetime
    dfvfs
    dfwinreg
    flor
    future
    libbde-python
    libcaes-python
    libcreg-python
    libesedb-python
    libevt-python
    libevtx-python
    libewf-python
    libfcrypto-python
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
    # This is required to support the darwin architecture for pyxattr
    (pyxattr.overrideAttrs (old: rec {
      buildInputs = lib.optional stdenv.isLinux pkgs.attr;
      meta.platforms = old.meta.platforms
        ++ [ "aarch64-darwin" "x86_64-darwin" ];
      hardeningDisable = lib.optional stdenv.isDarwin "strictoverflow";
    }))
    pyyaml
    pyzmq
    redis
    requests
    six
    XlsxWriter
    yara-python
    zstd
  ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description =
      "Plaso (Plaso Langar Að Safna Öllu), or super timeline all the things, is a Python-based engine used by several tools for automatic creation of timelines. Plaso default behavior is to create super timelines but it also supports creating more targeted timelines.";
    downloadPage = "https://github.com/log2timeline/plaso/releases";
    homepage = "https://github.com/log2timeline/plaso";
    license = licenses.asl20;
  };
}
