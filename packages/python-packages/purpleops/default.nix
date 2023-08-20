{ lib, fetchFromGitHub, python3Packages, ownPython, ... }:
let
  inherit (python3Packages) buildPythonPackage;

  pname = "PurpleOps";
  version = "7792663bca75f5aa75f96801228f92660d946d66";

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
    hash = "sha256-ygsLvrWYJeEHFttmKjgIwv9bswHcANOi/jxN3H+mId0=";
  };

  doCheck = false;

  propagatedBuildInputs = (with python3Packages; [
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
    email-validator
    et_xmlfile
    exceptiongroup
    flask
    flask_mail
    flask_principal
    flask-babelex
    flask-login
    flask-mailman
    flask-mongoengine
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
    pycparser
    pydantic
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
  ]) ++ (with ownPython; [
    docxcompose
    docxtpl
    flask-security
    phonenumberslite
  ]);

  postPatch = ''
    printf %s "$setupPy" > setup.py
  '';

in buildPythonPackage {
  inherit pname version meta setupPy src doCheck propagatedBuildInputs
    postPatch;
}
