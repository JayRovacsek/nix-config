{ lib, stdenvNoCC, fetchurl, _7zz }:
stdenvNoCC.mkDerivation {
  pname = "AnythingLLMDesktop";
  version = "1.5.0";
  sourceRoot = ".";
  nativeBuildInputs = [ _7zz ];

  src = fetchurl {
    url =
      "https://s3.us-west-1.amazonaws.com/public.useanything.com/latest/AnythingLLMDesktop-Silicon.dmg";
    hash = "sha256-m2D/ssD/asbVsTcdVsjpCjR6CNgvPsv926p20S7aHNI=";
  };

  # APFS is currently not supported by undmg
  unpackCmd = "${_7zz}/bin/7zz x -y -snld $curSrc";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r *.app $out/Applications
    runHook postInstall
  '';

  meta = with lib; {
    description =
      "Any LLM, unlimited documents, and fully private. All on your desktop.";
    platforms = platforms.darwin;
    homepage = "https://useanything.com/";
    downloadPage = "https://useanything.com/download";
    skip.ci = true;
  };
}
