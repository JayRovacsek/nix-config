{ stdenv, lib, dpkg, openssl, libnl, zlib, autoPatchelfHook, buildFHSUserEnv
, coreutils, bash, ... }:
let
  pname = "falcon-sensor";
  name = pname;

  src = ./falcon-sensor.deb;
  falcon-sensor = stdenv.mkDerivation {
    inherit src name pname;

    buildInputs = [ dpkg zlib autoPatchelfHook ];

    sourceRoot = ".";

    unpackPhase = "${dpkg}/bin/dpkg-deb -x $src . ";

    installPhase = "${coreutils}/bin/cp -r . $out";

    meta = with lib; {
      description = "Crowdstrike Falcon Sensor";
      homepage = "https://www.crowdstrike.com/";
      license = licenses.unfree;
      platforms = [ "x86_64-linux" ];
    };
  };
in buildFHSUserEnv {
  name = "fs-bash";
  targetPkgs = _pkgs: [ libnl openssl zlib ];

  extraInstallCommands = "${coreutils}/bin/ln -s ${falcon-sensor}/* $out/";

  runScript = "${bash}/bin/bash";
}
