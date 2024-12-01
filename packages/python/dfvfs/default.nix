{
  pkgs,
  lib,
  fetchPypi,
  python3Packages,
  self,
  stdenv,
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
  version = "20240505";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1stZe1ZnERKCg5Ww77bfv17fXvAaaESOi6oABQX6jwk=";
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
    # This is required to support the darwin architecture for pyxattr
    (pyxattr.overrideAttrs (old: rec {
      buildInputs = lib.optional stdenv.isLinux pkgs.attr;
      meta.platforms = old.meta.platforms ++ [
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      hardeningDisable = lib.optional stdenv.isDarwin "strictoverflow";
    }))
    pyyaml
  ];

  disabled = pythonOlder "3.8";

  # This is required only as the build process incorrectly assumes xattr
  # is not installed, despite it being included in dependencies.
  patches = [ ./no-xattr-dependency.patch ];

  pythonImportsCheck = [ pname ];

  meta = with lib; rec {
    changelog = "${homepage}/releases/tag/${version}";
    description = "dfVFS, or Digital Forensics Virtual File System, provides read-only access to file-system objects from various storage media types and file formats. The goal of dfVFS is to provide a generic interface for accessing file-system objects, for which it uses several back-ends that provide the actual implementation of the various storage media types, volume systems and file systems.";
    downloadPage = "https://github.com/log2timeline/dfvfs/releases";
    homepage = "https://github.com/log2timeline/dfvfs";
    license = licenses.asl20;
  };
}
