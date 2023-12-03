{ lib, stdenv, fetchFromGitHub, libsForQt5, cmake }:
stdenv.mkDerivation rec {
  pname = "dwarf-therapist";
  version = "42.1.2";

  src = fetchFromGitHub {
    owner = "Dwarf-Therapist";
    repo = "Dwarf-Therapist";
    rev = "v${version}";
    sha256 = "sha256-gBYMYPW/JCHrlKF9SwXlCwjcDgC5LTYfrxlGdL1HXP8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libsForQt5.qt5.qtbase libsForQt5.qt5.qtdeclarative ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Tool to manage dwarves in a running game of Dwarf Fortress";
    license = licenses.mit;
    platforms = [ "i686-linux" "x86_64-linux" ];
    homepage = "https://github.com/Dwarf-Therapist/Dwarf-Therapist";
  };
}
