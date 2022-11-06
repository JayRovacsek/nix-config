{ lib, stdenv, fetchFromGitLab, makeWrapper, coreutils, findutils, gnome
, gnugrep, temurin-jre-bin-17, openssl, ps, wget, which, xprop, libpulseaudio }:
let inherit (gnome) zenity;
in stdenv.mkDerivation rec {
  # This package was originally created at https://github.com/kira-bruneau/nur-packages
  # This will stay here and adheres to the license of the original author while
  # request https://github.com/kira-bruneau/nur-packages/pull/3 is completed/rejected 
  pname = "pokemmo-installer";
  version = "1.4.8";

  src = fetchFromGitLab {
    owner = "coringao";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-uSbnXBpkeGM9X6DU7AikT7hG/emu67PXuGdm6xfB8To=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installFlags = [
    "PREFIX=${placeholder "out"}"

    # BINDIR defaults to $(PREFIX)/games
    "BINDIR=${placeholder "out"}/bin"
  ];

  postFixup = ''
    wrapProgram "$out/bin/${pname}" \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          findutils
          gnugrep
          temurin-jre-bin-17
          openssl
          ps
          wget
          which
          xprop
          zenity
        ]
      } \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libpulseaudio ]}
  '';

  meta = with lib; {
    description = "Installer and Launcher for the PokeMMO emulator";
    homepage = "https://pokemmo.eu";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = platforms.linux;
  };
}
