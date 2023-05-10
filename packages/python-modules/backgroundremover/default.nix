{ lib, fetchPypi, python, ownPython, ... }:
let
  pname = "backgroundremover";
  name = pname;
  version = "0.2.1";

  meta = with lib; {
    description =
      "BackgroundRemover is a command line tool to remove background from image and video, made by nadermx to power https://BackgroundRemoverAI.com";
    platforms = platforms.all;
    homepage = "https://github.com/nadermx/backgroundremover";
    downloadPage = "https://github.com/nadermx/backgroundremover/releases";
    license = licenses.mit;
  };

  inherit (python)
    buildPythonPackage numpy certifi charset-normalizer filelock idna pysocks
    six urllib3 torch torchvision waitress tqdm requests scipy filetype
    more-itertools moviepy pillow ffmpeg-python scikitimage gdown;

  inherit (ownPython) hsh pymatting;

in buildPythonPackage {
  inherit pname name version meta;

  propagatedBuildInputs = [
    certifi
    charset-normalizer
    ffmpeg-python
    filelock
    filetype
    hsh
    idna
    more-itertools
    moviepy
    numpy
    pillow
    pymatting
    pysocks
    requests
    scikitimage
    scipy
    six
    torch
    torchvision
    tqdm
    urllib3
    waitress
    gdown
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-hh+NSFy2NgvgpsnTcFORzFfW4ZxX96nP4u9O+OpZw7Y=";
  };

  doCheck = false;

}
