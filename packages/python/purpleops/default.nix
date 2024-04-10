{ pkgs, lib, fetchFromGitHub, python3Packages, self, ... }:
let
  inherit (pkgs) system;

  pname = "PurpleOps";
  version = "14997923f44bf9870e9ab904034f57a4b46b18dc";

  meta = with lib; {
    inherit version;
    description =
      "An open-source self-hosted purple team management web application";
    platforms = platforms.all;
    homepage = "https://github.com/CyberCX-STA/PurpleOps";
    license = licenses.asl20;
  };

  setupPy = ''
    from setuptools import setup, find_packages

    with open('requirements.txt') as f:
        install_requires = f.read().splitlines()

    setup(
      name='${pname}',
      # packages=['${pname}'],
      packages=find_packages(exclude=['test']),
      version='0.1.0',
      description='${meta.description}',
      license='${meta.license.spdxId}',
      install_requires=install_requires,
      scripts=[
        'seeder.py',
        'purpleops.py',
      ]
    )
  '';

  src = fetchFromGitHub {
    owner = "CyberCX-STA";
    repo = pname;
    rev = meta.version;
    hash = "sha256-XeRuU5eWg9iE7OuNHQoumcALc1VzrBIdlrW1SGvUX+w=";
  };

  doCheck = false;

  inherit (self.packages.${system})
    docxcompose docxtpl flask-security phonenumberslite;

  inherit (python3Packages)
    buildPythonPackage anyio asn1crypto Babel bcrypt bleach blinker cbor2
    certifi cffi charset-normalizer click cryptography dnspython email-validator
    et_xmlfile exceptiongroup flask flask_mail flask_principal flask-babel
    flask-login flask-mailman flask-mongoengine flask-security-too
    flask-sqlalchemy flask-wtf gitdb GitPython greenlet gunicorn h11 httpcore
    idna importlib-metadata importlib-resources itsdangerous jinja2 lxml
    markupsafe mkdocs-material-extensions mongoengine openpyxl passlib pycparser
    pydantic pymongo pyopenssl pypng python-docx python-dotenv pytz pyyaml
    qrcode requests six smmap speaklater sqlalchemy sqlalchemy-utils
    typing-extensions urllib3 webauthn webencodings werkzeug wtforms zipp;

  propagatedBuildInputs = [
    anyio
    asn1crypto
    Babel
    bcrypt
    bleach
    blinker
    cbor2
    certifi
    cffi
    charset-normalizer
    click
    cryptography
    dnspython
    docxcompose
    docxtpl
    email-validator
    et_xmlfile
    exceptiongroup
    flask
    flask_mail
    flask_principal
    flask-babel
    flask-login
    flask-mailman
    flask-mongoengine
    flask-security
    flask-security-too
    flask-sqlalchemy
    flask-wtf
    gitdb
    GitPython
    greenlet
    gunicorn
    h11
    httpcore
    idna
    importlib-metadata
    importlib-resources
    itsdangerous
    jinja2
    lxml
    markupsafe
    mkdocs-material-extensions
    mongoengine
    openpyxl
    passlib
    phonenumberslite
    pycparser
    pydantic
    pymongo
    pymongo
    pyopenssl
    pypng
    python-docx
    python-dotenv
    pytz
    pyyaml
    qrcode
    requests
    six
    smmap
    speaklater
    sqlalchemy
    sqlalchemy-utils
    typing-extensions
    urllib3
    webauthn
    webencodings
    werkzeug
    wtforms
    zipp
  ];

  postPatch = ''
    printf %s "$setupPy" > setup.py
  '';

in buildPythonPackage {
  inherit pname version meta setupPy src doCheck propagatedBuildInputs
    postPatch;
}
