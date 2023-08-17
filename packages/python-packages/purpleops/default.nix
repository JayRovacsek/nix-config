{ lib, fetchFromGitHub, python, ownPython, ... }:
let
  inherit (python) buildPythonPackage fetchPypi;

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

  anyio = python.anyio.overrideAttrs (old: rec {
    version = "3.7.1";
    src = fetchFromGitHub {
      owner = "agronholm";
      repo = old.pname;
      rev = version;
      hash = "sha256-9/pAcVTzw9v57E5l4d8zNyBJM+QNGEuLKrQ0WUBW5xw=";
    };
  });

  certifi = python.certifi.overrideAttrs (old: rec {
    version = "2023.7.22";
    src = fetchFromGitHub {
      owner = old.pname;
      repo = "python-certifi";
      rev = "8fb96ed81f71e7097ed11bc4d9b19afd7ea5c909";
      hash = "sha256-V3bptJDNMGXlCMg6GHj792IrjfsG9+F/UpQKxeM0QOc=";
    };
  });

  charset-normalizer = python.charset-normalizer.overrideAttrs (_old: rec {
    version = "3.2.0";
    src = fetchFromGitHub {
      owner = "Ousret";
      repo = "charset_normalizer";
      rev = "refs/tags/${version}";
      hash = "sha256-CfL5rlrwJs9453z+1xPUzs1B3OyjFBaU6klzY7gJCzA=";
    };
  });

  dnspython = python.dnspython.overrideAttrs (old: rec {
    version = "2.4.0";
    src = fetchPypi {
      inherit (old) pname;
      inherit version;
      hash = "sha256-dY5pHbtFTVzPThsVShnlKEf3niGkL+8XuWkUSvKaTmw=";
    };
    propagatedBuildInputs = (with python; [ sniffio ]) ++ [ httpcore ];
  });

  flask-sqlalchemy = python.flask-sqlalchemy.overrideAttrs (old: rec {
    version = "3.0.5";
    src = fetchPypi {
      pname = "flask_sqlalchemy";
      inherit version;
      hash = "sha256-xXZeWMoUVAG1IQbA9GF4VpJDxdolVWviwjHsxghnxbE=";
    };
    propagatedBuildInputs = old.propagatedBuildInputs
      ++ (with python; [ flit-core ]);
  });

  httpcore = python.httpcore.overrideAttrs (old: rec {
    version = "0.17.3";
    src = fetchFromGitHub {
      owner = "encode";
      repo = old.pname;
      rev = "refs/tags/${version}";
      hash = "sha256-ZNtJnlLNBM6dEk7GBW5yAcAE4+3Q4TISHlBEApiM7IY=";
    };
  });

  importlib-resources = python.importlib-resources.overrideAttrs (_old: rec {
    version = "6.0.0";
    src = fetchPypi {
      pname = "importlib_resources";
      inherit version;
      hash = lib.fakeHash;
    };
  });

  mongoengine = python.mongoengine.overrideAttrs (old: rec {
    version = "0.27.0";
    src = fetchFromGitHub {
      owner = "MongoEngine";
      repo = old.pname;
      rev = "refs/tags/v${version}";
      hash = "sha256-UCd7RpsSNDKh3vgVRYrFYWYVLQuK7WI0n/Moukhq5dM=";
    };
  });

  pydantic = python.pydantic.overrideAttrs (old: rec {
    version = "1.10.11";
    src = fetchFromGitHub {
      owner = old.pname;
      repo = old.pname;
      rev = "refs/tags/v${version}";
      hash = "sha256-WxAM/RG69iBIYpq4EbHadRp5dFiXk4G9bVCaYNrp16s=";
    };

    patches = [ ];
  });

  pymongo = python.pymongo.overrideAttrs (old: rec {
    inherit (old) pname;
    version = "4.4.1";
    src = fetchPypi {
      inherit pname version;
      hash = "sha256-pN+H270DrGNy0k8qgFS03DPeSX1SJ7UOxkn0Nq1XQoQ=";
    };
  });

  sqlalchemy = python.sqlalchemy.overrideAttrs (_old: rec {
    version = "2.0.19";
    src = fetchFromGitHub {
      owner = "sqlalchemy";
      repo = "sqlalchemy";
      rev = "refs/tags/rel_${lib.replaceStrings [ "." ] [ "_" ] version}";
      hash = "sha256-97q04wQVtlV2b6VJHxvnQ9ep76T5umn1KI3hXh6a8kU=";
    };
  });

  webauthn = python.webauthn.overrideAttrs (old: rec {
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
  });

  overridden-packages = [
    anyio
    certifi
    charset-normalizer
    dnspython
    flask-sqlalchemy
    importlib-resources
    mongoengine
    pydantic
    pymongo
    sqlalchemy
    webauthn
  ];

  propagatedBuildInputs = (with python; [
    asn1crypto
    Babel
    bcrypt
    bleach
    cbor2
    cffi
    click
    cryptography
    et_xmlfile
    exceptiongroup
    flask
    flask_mail
    flask_principal
    flask-babelex
    flask-login
    flask-mailman
    flask-mongoengine
    flask-wtf
    gitdb
    GitPython
    greenlet
    gunicorn
    h11
    httpcore
    idna
    importlib-metadata
    itsdangerous
    jinja2
    lxml
    markupsafe
    mkdocs-material-extensions
    openpyxl
    passlib
    pycparser
    pydantic
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
    sqlalchemy-utils
    typing-extensions
    webencodings
    wtforms
    zipp
  ]) ++ (with ownPython; [
    blinker
    docxcompose
    docxtpl
    email-validator
    flask-security
    flask-security-too
    phonenumberslite
    urllib3
    werkzeug
  ]) ++ overridden-packages;

  postPatch = ''
    printf %s "$setupPy" > setup.py
  '';

in buildPythonPackage {
  inherit pname version meta setupPy src doCheck propagatedBuildInputs
    postPatch;
}
