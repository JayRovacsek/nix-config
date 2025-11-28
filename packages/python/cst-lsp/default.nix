{
  lib,
  python3,
  fetchFromGitHub,
  ...
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cst-lsp";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rowillia";
    repo = "cst-lsp";
    rev = "v.${version}";
    hash = "sha256-/CFaXr9y09St9NlfaqwGeLJe3Ggj/dQveFz6Ql9Vd40=";
  };

  build-system = [
    python3.pkgs.setuptools
  ];

  dependencies = with python3.pkgs; [
    libcst
    pygls
  ];

  optional-dependencies = with python3.pkgs; {
    dev = [
      pyright
      pytest
      ruff
    ];
  };

  pythonImportsCheck = [
    "cst_lsp"
  ];

  meta = {
    description = "LSP Server powered by libcst for refactoring tasks";
    homepage = "https://github.com/rowillia/cst-lsp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "cst-lsp";
  };
}
