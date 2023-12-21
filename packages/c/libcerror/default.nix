{ lib, stdenv, fetchFromGitHub, autoreconfHook, ... }:

stdenv.mkDerivation rec {

  nativeBuildInputs = [ autoreconfHook ];

  pname = "libcerror";
  version = "20220101";

  src = fetchFromGitHub {
    owner = "libyal";
    repo = "libcerror";
    rev = version;
    hash = "sha256-7IRnjb4jfZPlj1zJ1cbfnz0AEFT8TyI9yewl6/wnr90=";
  };

  meta = with lib; {
    description = "Library for cross-platform C error functions";
    homepage = "https://github.com/libyal/libcerror";
    changelog = "https://github.com/libyal/libcerror/blob/${src.rev}/NEWS";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    mainProgram = "libcerror";
    platforms = platforms.all;
  };
}
