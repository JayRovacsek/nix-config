{ pkgs, lib, fetchPypi, python3Packages, self, stdenv, ... }:
let
  inherit (pkgs) system;

  pname = "dfvfs";

  version = "20240115";

  meta = with lib; {
    description =
      "dfVFS, or Digital Forensics Virtual File System, provides read-only access to file-system objects from various storage media types and file formats. The goal of dfVFS is to provide a generic interface for accessing file-system objects, for which it uses several back-ends that provide the actual implementation of the various storage media types, volume systems and file systems.";
    platforms = platforms.all;
    homepage = "https://github.com/log2timeline/dfvfs";
    downloadPage = "https://github.com/log2timeline/dfvfs/releases";
    license = licenses.asl20;
  };

  inherit (python3Packages) buildPythonPackage cffi pyyaml pyxattr setuptools;

  inherit (self.packages.${system})
    dfdatetime dtfabric libbde-python libcaes-python libewf-python
    libfcrypto-python libfsapfs-python libfsext-python libfsfat-python
    libfshfs-python libfsntfs-python libfsxfs-python libfvde-python
    libfwnt-python libluksde-python libmodi-python libphdi-python libqcow-python
    libsigscan-python libsmdev-python libsmraw-python libvhdi-python
    libvmdk-python libvsapm-python libvsgpt-python libvshadow-python
    libvslvm-python pytsk3;

in buildPythonPackage {
  inherit pname version meta;

  patches = [ ./no-xattr-dependency.patch ];

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    cffi
    dfdatetime
    dtfabric
    libbde-python
    libcaes-python
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
    libluksde-python
    libmodi-python
    libphdi-python
    libqcow-python
    libsigscan-python
    libsmdev-python
    libsmraw-python
    libvhdi-python
    libvmdk-python
    libvsapm-python
    libvsgpt-python
    libvshadow-python
    libvslvm-python
    pytsk3
    (pyxattr.overrideAttrs (old: rec {
      buildInputs = lib.optional stdenv.isLinux pkgs.attr;
      meta.platforms = old.meta.platforms
        ++ [ "aarch64-darwin" "x86_64-darwin" ];
      hardeningDisable = lib.optional stdenv.isDarwin "strictoverflow";
    }))
    pyyaml
  ];

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-FkOB26OdxD9j82oaQFqtGYxKdjGQRLZNCFDq7dOKt7s=";
  };
}
