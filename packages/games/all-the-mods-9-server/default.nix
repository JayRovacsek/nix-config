{ coreutils, curl, buildFHSEnv, jre17_minimal, lib, lndir, stdenvNoCC, fetchurl
, unzip, ... }:
let
  version = "9-0.2.29";
  pname = "all-the-mods-server";

  atm-core = stdenvNoCC.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "https://edge.forgecdn.net/files/4950/736/Server-Files-0.2.29b.zip";
      hash = "sha256-tGygKHjR7IMq60jyNNLvqWTTKwmDllNAmSpvgZUgLKM=";
    };

    nativeBuildInputs = [ unzip ];

    buildPhase = ''
      mkdir -p $out/bin $out/lib

      ${unzip}/bin/unzip $src -d $out/lib
      ${coreutils}/bin/mv $out/lib/Server-Files-0.2.29 $out/lib/minecraft
      chmod +x $out/lib/minecraft/startserver.sh
    '';

    meta = with lib; {
      description = "All The Mods Server";
      homepage = "https://github.com/AllTheMods/ATM-9";
      platforms = platforms.unix;
    };
  };

  atm = stdenvNoCC.mkDerivation {
    inherit pname version;

    buildPhase = ''
      mkdir -p $out/bin $out/lib

      ln -s ${atm-core}/lib/minecraft $out/lib/minecraft
      cp ${atm-core}/lib/minecraft/startserver.sh $out/bin/minecraft-server

      substituteInPlace $out/bin/minecraft-server \
        --replace 'INSTALLER="forge-1.20.1-$FORGE_VERSION-installer.jar"' 'INSTALLER="/tmp/forge-1.20.1-$FORGE_VERSION-installer.jar"' \
        --replace ' -jar "$INSTALLER" -installServer' ' -Dfile.name=/tmp/minecraft.log -jar "$INSTALLER" -installServer'
    '';

    meta = with lib; {
      description = "All The Mods Server";
      homepage = "https://github.com/AllTheMods/ATM-9";
      platforms = platforms.unix;
    };
  };

  fhs = buildFHSEnv {
    name = pname;
    targetPkgs = pkgs: with pkgs; [ jre17_minimal curl ];
    runScript = "${atm}/bin/minecraft-server";
  };

in stdenvNoCC.mkDerivation {
  inherit (atm) pname meta version;

  dontUnpack = true;

  installPhase = ''
    mkdir $out
    ${lndir}/bin/lndir -silent ${fhs} $out
  '';
}
