{ stdenv, lib, fetchFromGitHub }:
with lib;
let
  name = "catppuccin-base16";
  pname = name;
  version = "0.0.1";
  meta = {
    description = "Soothing pastel theme for base16 (WIP) ";
    platforms = platforms.all;
    homepage = "https://github.com/catppuccin/base16";
    downloadPage = "https://github.com/catppuccin/base16";
    license = licenses.mit;
  };

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "base16";
    rev = "ca74b4070d6ead4213e92da1273fcc1853de7af8";
    sha256 = "sha256-fZDsmJ+xFjOJDoI+bPki9W7PEI5lT5aGoCYtkatcZ8A=";
  };

  phases = [ "installPhase" "fixupPhase" ];

in stdenv.mkDerivation {
  inherit name pname version meta phases src;

  installPhase = ''
    mkdir -p $out/share/themes
    ln -s $src/base16/* $out/share/themes
  '';
}
