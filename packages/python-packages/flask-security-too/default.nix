{ lib, python, ... }:
let

  inherit (python)
    buildPythonPackage fetchPypi babel flask-babel bcrypt bleach flask-mailman
    qrcode flask-sqlalchemy sqlalchemy sqlalchemy-utils cryptography
    phonenumbers blinker email-validator flask flask_login flask_principal
    flask-wtf itsdangerous passlib;

in buildPythonPackage rec {
  pname = "flask-security-too";
  version = "5.0.2";

  src = fetchPypi {
    pname = "Flask-Security-Too";
    inherit version;
    sha256 = "sha256-Nv7g2l0bPSEcrydFU7d1NHjCCJl8Ykq7hOu6QmHeZcI=";
  };

  propagatedBuildInputs = [
    blinker
    email-validator
    flask
    flask_login
    flask_principal
    flask-wtf
    itsdangerous
    passlib
  ];

  doCheck = false;

  passthru.optional-dependencies = {
    babel = [ babel flask-babel ];
    common = [ bcrypt bleach flask-mailman qrcode ];
    fsqla = [ flask-sqlalchemy sqlalchemy sqlalchemy-utils ];
    mfa = [ cryptography phonenumbers ];
  };

  meta = with lib; {
    homepage = "https://pypi.org/project/Flask-Security-Too/";
    description = "Simple security for Flask apps (fork)";
    license = licenses.mit;
  };
}
