# https://nixos.wiki/wiki/Packaging/Binaries
{ pkgs, lib, stdenv, fetchurl, autoPatchelfHook, systemd }:
let
  inherit (pkgs) system;

  pname = "velociraptor";
  name = pname;
  appname = pname;
  version = "0.6.7-5";

  meta = with lib; {
    homepage = "https://docs.velociraptor.app/";
    description = "Velociraptor";
    license = licenses.mit;
  };

  hashes = {
    "x86_64-linux" = "sha256-9ORkd6WAeL1jyYKRrK0Y9SOF/XRylQb+XQvxlRL6kc8=";
    "x86_64-darwin" = lib.fakeHash;
    "aarch64-linux" = lib.fakeHash;
    "aarch64-darwin" = lib.fakeHash;
  };

  parts = builtins.filter builtins.isString (builtins.split "-" pkgs.system);
  kernel = builtins.head (builtins.tail parts);
  nixArch = builtins.head parts;
  archMap = { "x86_64" = "amd64"; };
  arch = builtins.getAttr nixArch archMap;

  filename = "${pname}-v${version}-${kernel}-${arch}";

  src = fetchurl {
    url =
      "https://github.com/Velocidex/velociraptor/releases/download/v${version}/${filename}";
    sha256 = builtins.getAttr system hashes;
  };

  linux = stdenv.mkDerivation {
    inherit pname version src filename;
    buildInputs = [ systemd ];

    dontUnpack = true;

    nativeBuiltInputs = [ autoPatchelfHook ];

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/${pname}
    '';

    postFixup = ''
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/${pname}

      chmod +x $out/bin/${pname}
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit pname version src filename;
    meta = meta // { platforms = [ "x86_64-darwin" "aarch64-darwin" ]; };
    buildInputs = [ systemd ];

    dontUnpack = true;

    nativeBuiltInputs = [ autoPatchelfHook ];

    installPhase = ''
      mkdir -p $out/Applications
      cp $src $out/Applications/${filename}
    '';

    postFixup = ''
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/Applications/${filename}

      chmod +x $out/Applications/${filename}
    '';
  };
in if stdenv.isDarwin then darwin else linux
