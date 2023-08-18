{ python, fetchFromGitHub, ... }:
python.httpcore.overrideAttrs (old: rec {
  version = "0.17.3";
  src = fetchFromGitHub {
    owner = "encode";
    repo = old.pname;
    rev = "refs/tags/${version}";
    hash = "sha256-ZNtJnlLNBM6dEk7GBW5yAcAE4+3Q4TISHlBEApiM7IY=";
  };
})
