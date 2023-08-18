{ python, fetchFromGitHub, ... }:
python.anyio.overrideAttrs (old: rec {
  version = "3.7.1";
  src = fetchFromGitHub {
    owner = "agronholm";
    repo = old.pname;
    rev = version;
    hash = "sha256-9/pAcVTzw9v57E5l4d8zNyBJM+QNGEuLKrQ0WUBW5xw=";
  };
})
