{ python, ... }:
let inherit (python) fetchPypi;
in python.pymongo.overrideAttrs (old: rec {
  inherit (old) pname;
  version = "4.4.1";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pN+H270DrGNy0k8qgFS03DPeSX1SJ7UOxkn0Nq1XQoQ=";
  };
})
