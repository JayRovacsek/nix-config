{ python, ... }:
let inherit (python) fetchPypi;
in python.importlib-resources.overrideAttrs (_old: rec {
  version = "6.0.0";
  src = fetchPypi {
    pname = "importlib_resources";
    inherit version;
    hash = "sha256-TPlIdag2i9iVMadW35qevh8VDg+IUDC0YSN7x/LZBfI=";
  };
})
