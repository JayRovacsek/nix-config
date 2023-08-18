{ python, fetchFromGitHub, ... }:
python.certifi.overrideAttrs (old: rec {
  version = "2023.7.22";
  src = fetchFromGitHub {
    owner = old.pname;
    repo = "python-certifi";
    rev = "8fb96ed81f71e7097ed11bc4d9b19afd7ea5c909";
    hash = "sha256-V3bptJDNMGXlCMg6GHj792IrjfsG9+F/UpQKxeM0QOc=";
  };
})
