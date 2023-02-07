# https://nixos.wiki/wiki/Packaging/Binaries
{ pkgs, lib, stdenv, fetchurl, unzip, autoPatchelfHook }:
let
  inherit (pkgs) system;
  inherit (pkgs.stdenv) isDarwin isLinux;
  inherit (lib.lists) optional;

  pname = "trdsql";
  name = pname;
  appname = pname;
  version = "0.10.1";

  meta = with lib; {
    homepage = "https://github.com/noborus/trdsql";
    description =
      "CLI tool that can execute SQL queries on CSV, LTSV, JSON and TBLN.";
    license = licenses.mit;
    platforms =
      [ "x86_64-darwin" "aarch64-darwin" "x86_64-linux" "aarch64-linux" ];
  };

  hashes = {
    "x86_64-linux" = lib.fakeHash;
    "x86_64-darwin" = lib.fakeHash;
    "aarch64-linux" = lib.fakeHash;
    "aarch64-darwin" = "sha256-UsHb/SLIf2xk07cCSfGT1gHwLCgBkaztYgGkZD+n1X4=";
  };

  archMap = {
    "x86_64" = "amd64";
    "aarch64" = "arm64";
  };

  parts = builtins.filter builtins.isString (builtins.split "-" pkgs.system);
  kernel = builtins.head (builtins.tail parts);
  nixArch = builtins.head parts;
  arch = builtins.getAttr nixArch archMap;

  filename = "${pname}_v${version}_${kernel}_${arch}";
  zipFilename = "${filename}.zip";

  src = fetchurl {
    url =
      "https://github.com/noborus/trdsql/releases/download/v${version}/${zipFilename}";
    sha256 = builtins.getAttr system hashes;
  };

  optionalPatchelfCommand = if isLinux then
    ''
      ${pkgs.patchelf} --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/${pname}''
  else
    "";

in stdenv.mkDerivation {
  inherit pname version src filename meta;
  buildInputs = [ unzip ] ++ optional isLinux [ systemd ];

  nativeBuiltInputs = [ ] ++ optional isLinux [ autoPatchelfHook ];

  installPhase = ''
    ${pkgs.unzip}/bin/unzip $src
    mkdir -p $out/bin
    cp ${filename}/${pname} $out/bin/${pname}
  '';

  postFixup = ''
    ${optionalPatchelfCommand}

    chmod +x $out/bin/${pname}
  '';
}
