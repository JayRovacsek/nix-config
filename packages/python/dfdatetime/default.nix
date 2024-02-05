{ lib, fetchPypi, python3Packages, ... }:
let
  pname = "dfdatetime";
  name = pname;
  version = "20231205";

  meta = with lib; {
    description =
      "dfDateTime, or Digital Forensics date and time, provides date and time objects to preserve accuracy and precision.";
    platforms = platforms.all;
    homepage = "https://github.com/log2timeline/dfdatetime";
    downloadPage = "https://github.com/log2timeline/dfdatetime/releases";
    license = licenses.asl20;
  };

  inherit (python3Packages) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OG26dfWSPtOkewX50n82qa1yn1rGtmjKKM0t/uZUEtg=";
  };

  doCheck = false;
}
