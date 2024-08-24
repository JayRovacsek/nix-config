{
  lib,
  fetchPypi,
  python3Packages,
  ...
}:
let
  pname = "Flask-Security";
  version = "3.0.0";

  meta = with lib; {
    description = "It quickly adds security features to your Flask application.";

    homepage = "https://github.com/mattupstate/flask-security";
    downloadPage = "https://github.com/mattupstate/flask-security/tags";
    license = licenses.mit;
  };

  inherit (python3Packages) buildPythonPackage;

  dependencies = with python3Packages; [
    Babel
    flask
    flask_mail
    flask_principal
    flask-babel
    flask-login
    flask-wtf
    itsdangerous
    passlib
    pytest-runner
  ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1h2qX1pI+J8w9QVVhyvfWBssZYBGaLAxM0XNe+/yZDI=";
  };

  doCheck = false;

in
buildPythonPackage {
  inherit
    pname
    version
    meta
    dependencies
    src
    doCheck
    ;
}
