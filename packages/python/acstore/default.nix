{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "acstore";
  name = pname;
  version = "20230519";

  meta = with lib; {
    description =
      "ACStore, or Attribute Container Storage, provides a stand-alone implementation to read and write attribute container storage files.";
    platforms = platforms.all;
    homepage = "https://github.com/log2timeline/acstore";
    downloadPage = "https://github.com/log2timeline/acstore/releases";
    license = licenses.asl20;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ufbXsWCbl1j8CUTsJeRD3gvRrLaVc4jC3lrMZB4T2Ag=";
  };

  doCheck = false;

}
