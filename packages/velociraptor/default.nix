{ pkgs, stdenv, lib, buildGoModule, fetchFromGitHub, nodejs, go }:
let
  # WARNING: THIS DOES NOT WORK CURRENTLY
  pname = "velociraptor";
  version = "0.6.4-2";

  meta = with lib; {
    description =
      "Velociraptor is a tool for collecting host based state information using Velociraptor Query Language (VQL)";
    homepage = "https://docs.velociraptor.app/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ jayrovacsek ];
  };

  src = fetchFromGitHub {
    owner = "velocidex";
    repo = pname;
    rev = "v${version}";
    sha256 = lib.fakeHash;
  };

  parts = builtins.filter builtins.isString (builtins.split "-" pkgs.system);
  system = builtins.tail parts;
  arch = builtins.head parts;

  makeSystem = if arch == "aarch64" then "${system}_m1" else system;

in stdenv.mkDerivation {
  inherit pname version src meta;

  buildInputs = [ nodejs go ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin

    pushd gui/velociraptor/
    npm install
    popd
    make ${builtins.toString makeSystem}

    mv velociraptor $out/bin
    chmod +x velociraptor

    runHook postInstall
  '';
}
