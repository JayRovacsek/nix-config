# https://nixos.wiki/wiki/Packaging/Binaries
{ pkgs, lib, stdenv, fetchFromGitHub, buildGoModule }:
let
  inherit (pkgs) system;
  inherit (pkgs.stdenv) isLinux;
  inherit (lib.lists) optional;

  pname = "pdscan";
  name = pname;
  version = "0.1.8";

  meta = with lib; {
    homepage = "https://github.com/ankane/pdscan";
    description = "Scan your data stores for unencrypted personal data (PII)";
    license = licenses.mit;
  };

  src = fetchFromGitHub {
    owner = "ankane";
    repo = "pdscan";
    rev = "v${version}";
    sha256 = "sha256-F4owE2IFj9r/HcmFQ/63HlE15xrhdGe/aU6anSnPmWM=";
  };

  vendorHash = "sha256-Dx4zjVMgKye5vYoinX6CnQdSCQ+8Ryd2i3ToHlnBjcI=";

  doCheck = false;

in buildGoModule { inherit pname version src meta vendorHash doCheck; }
