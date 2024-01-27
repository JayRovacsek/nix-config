{ pkgs, lib, fetchPypi, python3Packages, self, ... }:
let
  inherit (pkgs) system;

  pname = "backgroundremover";
  name = pname;
  version = "0.2.6";

  meta = with lib; {
    description =
      "BackgroundRemover is a command line tool to remove background from image and video, made by nadermx to power https://BackgroundRemoverAI.com";
    platforms = platforms.all;
    homepage = "https://github.com/nadermx/backgroundremover";
    downloadPage = "https://github.com/nadermx/backgroundremover/releases";
    license = licenses.mit;
  };

  inherit (python3Packages)
    buildPythonPackage numpy certifi charset-normalizer filelock idna pysocks
    six urllib3 torch torchvision waitress tqdm requests scipy filetype
    more-itertools moviepy pillow ffmpeg-python scikitimage gdown;

  inherit (self.packages.${system}) hsh pymatting;

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
    sha256 = "sha256-YAiPwI7YCTIDJxgzEoVCT/6htRemcVuvfj2lVS3dlks=";
  };

  doCheck = false;

}
