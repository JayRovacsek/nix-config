{ python, ownPython, ... }:
let
  inherit (python) fetchPypi;
  inherit (ownPython) httpcore;
in python.dnspython.overrideAttrs (old: rec {
  version = "2.4.0";
  src = fetchPypi {
    inherit (old) pname;
    inherit version;
    hash = "sha256-dY5pHbtFTVzPThsVShnlKEf3niGkL+8XuWkUSvKaTmw=";
  };
  propagatedBuildInputs = (with python; [ sniffio ]) ++ [ httpcore ];
})
