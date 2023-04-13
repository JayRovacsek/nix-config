# https://nixos.wiki/wiki/Packaging/Binaries
{ pkgs, lib, stdenv, fetchurl, unzip, autoPatchelfHook }:
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
    platforms = [ "x86_64-darwin" "aarch64-darwin" "x86_64-linux" "aarch64-linux" ];
  };

  hashes = {
    "x86_64-linux" = lib.fakeHash;
    "x86_64-darwin" = lib.fakeHash;
    "aarch64-linux" = lib.fakeHash;
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
    url = "https://github.com/ankane/pdscan/releases/download/v${version}/${zipFilename}";
    sha256 = builtins.getAttr system hashes;
  };

  optionalPatchelfCommand = if isLinux then
    ''${pkgs.patchelf}/bin/patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/${pname}''
  else
    "";

in stdenv.mkDerivation {
  inherit name pname version src filename meta;
  buildInputs = [ unzip ] ++ optional isLinux [ ];

  nativeBuiltInputs = [ ] ++ optional isLinux [ autoPatchelfHook ];

  installPhase = ''
    ${pkgs.unzip}/bin/unzip $src
    mkdir -p $out/bin
    cp ${pname} $out/bin/${pname}
  '';

  postFixup = ''
    ${optionalPatchelfCommand}

    chmod +x $out/bin/${pname}
  '';
}
