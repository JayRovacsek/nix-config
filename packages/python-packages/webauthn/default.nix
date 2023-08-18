{ python, ownPython, fetchFromGitHub, ... }:
let inherit (ownPython) pydantic;
in python.webauthn.overrideAttrs (old: rec {
  version = "1.9.0";
  src = fetchFromGitHub {
    owner = "duo-labs";
    repo = "py_webauthn";
    rev = "refs/tags/v${version}";
    hash = "sha256-bcAAoaa2E6BzqaiEBOE+AGDSg3P9uqEoiqeT4FBjZcs=";
  };

  propagatedBuildInputs =
    (builtins.filter (x: x.pname != "pydantic") old.propagatedBuildInputs)
    ++ [ pydantic ];
})
