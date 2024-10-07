{
  lib,
  stdenv,
  coreutils,
  fetchurl,
  pkgs,
  ...
}:
let
  bedrock-connect-bin = fetchurl {
    url = "https://github.com/Pugmatt/BedrockConnect/releases/download/1.50/BedrockConnect-1.0-SNAPSHOT.jar";
    hash = "sha256-C81izQoMmFuewfDRBeIgzUGivKgNXKy/WbLua+E1OeM=";
  };

  wrapper = pkgs.writeShellScriptBin "bedrock-connect" ''
    ${pkgs.temurin-jre-bin-8}/bin/java -jar ${bedrock-connect-bin}
  '';
in
stdenv.mkDerivation {
  pname = "bedrock-connect";
  version = "1.50";

  src = null;

  phases = [ "installPhase" ];

  installPhase = ''
    ${coreutils}/bin/mkdir -p $out/bin
    ${coreutils}/bin/cp -r ${wrapper}/bin/bedrock-connect $out/bin
  '';

  meta = {
    description = "Join any Minecraft Bedrock Edition server IP on Xbox One, Nintendo Switch, and PS4/PS5";
    homepage = "https://github.com/Pugmatt/BedrockConnect";
    license = lib.licenses.gpl3Only;
    mainProgram = "bedrock-connect";
    platforms = lib.platforms.all;
  };
}
