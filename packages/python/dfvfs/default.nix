{
  pkgs,
  lib,
  fetchPypi,
  python3Packages,
  self,
  ...
}:
let
  inherit (pkgs) system;

  inherit (python3Packages)
    buildPythonPackage
    cffi
    pyyaml
    pyxattr
    pythonOlder
    setuptools
    ;

  inherit (self.packages.${system})
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
    ;

in
buildPythonPackage rec {
  pname = "dfvfs";
  version = "20260731";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DUSiqDtRRD6ViM4W+JZa3aZ0ID1ruyL+mSa+N/mJJC8=";
  };

  build-system = [ setuptools ];

  dependencies = [
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
    pyxattr
    pyyaml
  ];

  pythonRemoveDeps = [ "xattr" ];

  disabled = pythonOlder "3.8";

  pythonImportsCheck = [ pname ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "dfVFS, or Digital Forensics Virtual File System, provides read-only access to file-system objects from various storage media types and file formats. The goal of dfVFS is to provide a generic interface for accessing file-system objects, for which it uses several back-ends that provide the actual implementation of the various storage media types, volume systems and file systems.";
    downloadPage = "https://github.com/log2timeline/dfvfs/releases";
    homepage = "https://github.com/log2timeline/dfvfs";
    license = licenses.asl20;
  };
}
