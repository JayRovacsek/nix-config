# https://nixos.wiki/wiki/Packaging/Binaries
{ pkgs, lib, stdenv, fetchurl, unzip }:
let
  inherit (pkgs) system;
  inherit (pkgs.stdenv) isLinux;
  inherit (lib.lists) optional;

  pname = "pdscan";
  name = pname;
  version = "0.1.7";

  meta = with lib; {
    homepage = "https://github.com/ankane/pdscan";
    description = "Scan your data stores for unencrypted personal data (PII)";
    license = licenses.mit;
    platforms =
      [ "x86_64-darwin" "aarch64-darwin" "x86_64-linux" "aarch64-linux" ];
  };

  hashes = {
    "x86_64-linux" = "sha256-Bo3UXLGsRlQUUHDmk3odhpOBt0diJ6MiS9YT1Wuv8qQ=";
    "x86_64-darwin" = "sha256-8E5KOKWGD9OYryV/5Gc+3NNaEHSKaQXUgG6+6ccF36E=";
    "aarch64-linux" = "sha256-j2pasGFRg+p2pI1z+ZLJ8CnnGM4KofzZcRLRGhrTJtI=";
    "aarch64-darwin" = "sha256-ypqiWFa2arYs9nRGCaK6FSGf5rA12dyXPCVzNP4GhI0=";
  };

  archMap = {
    "x86_64" = "x86_64";
    "aarch64" = "arm64";
  };

  parts = builtins.filter builtins.isString (builtins.split "-" pkgs.system);
  kernel = builtins.head (builtins.tail parts);
  nixArch = builtins.head parts;
  arch = builtins.getAttr nixArch archMap;

  filename = "${pname}-${version}-${arch}-${kernel}";
  zipFilename = "${filename}.zip";

  src = fetchurl {
    url =
      "https://github.com/ankane/pdscan/releases/download/v${version}/${zipFilename}";
    sha256 = builtins.getAttr system hashes;
  };

in stdenv.mkDerivation {
  inherit name pname version src filename meta;
  buildInputs = [ unzip ] ++ optional isLinux [ ];

  installPhase = ''
    ${unzip}/bin/unzip $src
    mkdir -p $out/bin
    cp ${pname} $out/bin/${pname}
  '';

  postFixup = ''
    chmod +x $out/bin/${pname}
  '';
}
