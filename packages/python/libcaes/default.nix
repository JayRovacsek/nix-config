{ lib, python3Packages, fetchFromGitHub, autoreconfHook, automake, gcc, ... }:
let
  inherit (python3Packages) buildPythonApplication;

  libcerror = fetchFromGitHub {
    owner = "libyal";
    repo = "libcerror";
    rev = "20220101";
    hash = "sha256-7IRnjb4jfZPlj1zJ1cbfnz0AEFT8TyI9yewl6/wnr90=";
  };

  pname = "libcaes";
  version = "20231120";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "libyal";
    repo = "libcaes";
    rev = version;
    hash = "sha256-poR+Ir0M0ja3Qg01cO6rcF0JIECII2lq5xf62+LYyrE=";
  };

  nativeBuildInputs = [ automake autoreconfHook gcc ]
    ++ (with python3Packages; [ setuptools wheel ]);

  pythonImportsCheck = [ "libcaes" ];

  meta = with lib; {
    description = "Library to support cross-platform AES encryption";
    homepage = "https://github.com/libyal/libcaes";
    changelog = "https://github.com/libyal/libcaes/blob/${src.rev}/NEWS";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    mainProgram = "libcaes";
  };

in buildPythonApplication {
  inherit pname version pyproject src nativeBuildInputs pythonImportsCheck meta;

  postPatch = ''
    substituteInPlace configure.ac \
      --replace 'AC_CONFIG_FILES([libcerror/Makefile])' 'AC_CONFIG_FILES([${libcerror}/Makefile])'
  '';
}
