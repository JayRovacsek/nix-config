{
  stdenv,
  fetchzip,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  pname = "aerospace";
  version = "0.12.0-Beta";
  nativeBuildInputs = [ installShellFiles ];
  buildPhase = "";
  installPhase = ''
    mkdir -p $out/bin
    cp bin/aerospace $out/bin

    mkdir -p $out/Applications
    cp -r AeroSpace.app $out/Applications/AeroSpace.app

    installManPage manpage/*
  '';

  src = fetchzip {
    url = "https://github.com/nikitabobko/AeroSpace/releases/download/v${version}/AeroSpace-v${version}.zip";
    hash = "sha256-8po13LnL5x5mGIjPmtyH7yVm3htAJ2CyNpqSb1yLt0Q=";
  };
}
