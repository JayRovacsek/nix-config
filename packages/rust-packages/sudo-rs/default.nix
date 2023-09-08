{ lib, fetchFromGitHub, rustPlatform }:
let
  inherit (rustPlatform) buildRustPackage;
  pname = "sudo-rs";
  version = "0.2.0";

  meta = with lib; {
    homepage = "https://github.com/memorysafety/sudo-rs";
    description = "A memory safe implementation of sudo and su";
    license = licenses.asl20;
  };

  src = fetchFromGitHub {
    owner = "memorysafety";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Kk5D3387hdl6eGWTSV003r+XajuDh6YgHuqYlj9NnaQ=";
  };

  cargoSha256 = "sha256-yeMK37tOgJcs9pW3IclpR5WMXx0gMDJ2wcmInxJYbQ8=";

in buildRustPackage { inherit pname version src meta cargoSha256; }
