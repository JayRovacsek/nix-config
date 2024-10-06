{
  autoPatchelfHook,
  coreutils,
  curl,
  fetchurl,
  gcc-unwrapped,
  lib,
  openssl,
  patchelf,
  stdenv,
  unzip,
  ...
}:
# Thanks to https://github.com/gensokyo-zone/infrastructure for the below
stdenv.mkDerivation rec {
  pname = "minecraft-bedrock-server";
  version = "1.21.31.04";
  src = fetchurl {
    url = "https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-${version}.zip";
    hash = "sha256-LobT9vVF+i5M1nNuXxL7rxkjJhIyq7/pN6CNO76UXGA=";
    curlOptsList = [
      "-HUser-Agent: Mozilla/5.0 (Windows NT 10.0; rv:130.0) Gecko/20100101 Firefox/130.0"
    ];
  };

  nativeBuildInputs = [
    (patchelf.overrideDerivation (_old: {
      postPatch = ''
        substituteInPlace src/patchelf.cc \
          --replace "32 * 1024 * 1024" "512 * 1024 * 1024"
      '';
    }))
    autoPatchelfHook
    curl
    gcc-unwrapped
    openssl
    unzip
  ];

  dataDir = "/var/lib/minecraft-bedrock";

  sourceRoot = ".";

  installPhase = ''
    ${coreutils}/bin/install -m755 -D bedrock_server $out/bin/bedrock_server
    ${coreutils}/bin/install -d $out$dataDir
    ${coreutils}/bin/cp -a definitions behavior_packs resource_packs config env-vars *.json *.debug *.properties $out$dataDir/
  '';

  fixupPhase = ''
    autoPatchelf $out/bin/bedrock_server
  '';

  dontStrip = true;

  meta = {
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.unfree;
    mainProgram = "bedrock_server";
  };
}
