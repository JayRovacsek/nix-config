{ python, ... }:
let inherit (python) fetchPypi;
in python.flask-sqlalchemy.overrideAttrs (old: rec {
  version = "3.0.5";
  src = fetchPypi {
    pname = "flask_sqlalchemy";
    inherit version;
    hash = "sha256-xXZeWMoUVAG1IQbA9GF4VpJDxdolVWviwjHsxghnxbE=";
  };
  propagatedBuildInputs = old.propagatedBuildInputs
    ++ (with python; [ flit-core ]);
})
