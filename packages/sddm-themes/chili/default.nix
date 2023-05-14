{ lib, stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "chili-sddm-theme";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "MarianArlt";
    repo = "sddm-chili";
    rev = "${version}";
    sha256 = "sha256-wxWsdRGC59YzDcSopDRzxg8TfjjmA3LHrdWjepTuzgw=";
  };

  installPhase = ''
    mkdir -p $out/share/sddm/themes/chili
    mv * $out/share/sddm/themes/chili/
  '';

  meta = with lib; {
    license = licenses.gpl3;
    homepage = "https://github.com/MarianArlt/sddm-chili";
    description =
      "The hottest theme around for SDDM, the Simple Desktop Display Manager.";
  };
}
