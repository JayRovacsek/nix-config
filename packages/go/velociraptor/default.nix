{
  lib,
  stdenv,
  autoPatchelfHook,
  fetchurl,
  coreutils,
  patchelf,
}:
let
  inherit (stdenv) system;

  hashes = {
    "x86_64-linux" = "sha256-0R+BkfRK+kFWLUvwgGcrfjyhI0XRlyRYr1XPCpQWWP4=";
    "aarch64-linux" = "sha256-GkntPHcyY4hBM3t/Lijs0FT28QtYnnvVWYANW8ynp40=";
  };

  arch-map = {
    "x86_64" = "amd64";
    "aarch64" = "arm64";
  };

  parts = with builtins; filter isString (split "-" system);
  kernel = with builtins; head (tail parts);
  nix-arch = builtins.head parts;
  arch = builtins.getAttr nix-arch arch-map;

  pname = "velociraptor";
  version = "0.73";

  minor-version = "3";

  filename = "${pname}-v${version}.${minor-version}-${kernel}-${arch}";

in
stdenv.mkDerivation rec {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/Velocidex/${pname}/releases/download/v${version}/${filename}";
    sha256 = builtins.getAttr system hashes;
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/${pname}
  '';

  nativeBuiltInputs = [ autoPatchelfHook ];

  optionalPatchelfCommand = ''${patchelf}/bin/patchelf --set-interpreter "$(${coreutils}/bin/cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/${pname}'';

  postFixup = ''
    ${optionalPatchelfCommand}

    chmod +x $out/bin/${pname}
  '';

  meta = with lib; {
    description = "Digging Deeper";
    homepage = "https://github.com/Velocidex/velociraptor";
    license = licenses.agpl3Only;
    mainProgram = "velociraptor";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
