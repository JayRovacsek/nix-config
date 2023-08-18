{ python, fetchFromGitHub, ... }:
python.pydantic.overrideAttrs (old: rec {
  version = "1.10.11";
  src = fetchFromGitHub {
    owner = old.pname;
    repo = old.pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-WxAM/RG69iBIYpq4EbHadRp5dFiXk4G9bVCaYNrp16s=";
  };

  patches = [ ];
})
