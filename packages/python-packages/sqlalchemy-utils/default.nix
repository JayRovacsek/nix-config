{ lib, python, ... }:
let
  inherit (python)
    buildPythonPackage fetchPypi pythonOlder importlib-metadata sqlalchemy babel
    arrow pendulum phonenumbers passlib colour python-dateutil furl cryptography
    pytestCheckHook pygments jinja2 docutils flexmock psycopg2 psycopg2cffi
    pg8000 pytz backports-zoneinfo pymysql pyodbc;
in buildPythonPackage rec {
  pname = "sqlalchemy-utils";
  version = "0.41.1";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "SQLAlchemy-Utils";
    hash = "sha256-ohgb/wHuuER544Vx0sBxjrUgQvmv2MGU0NAod+hLfXQ=";
  };

  doCheck = false;

  patches = [ ./skip-database-tests.patch ];

  propagatedBuildInputs = [ sqlalchemy ]
    ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  passthru.optional-dependencies = {
    babel = [ babel ];
    arrow = [ arrow ];
    pendulum = [ pendulum ];
    #intervals = [ intervals ];
    phone = [ phonenumbers ];
    password = [ passlib ];
    color = [ colour ];
    timezone = [ python-dateutil ];
    url = [ furl ];
    encrypted = [ cryptography ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pygments
    jinja2
    docutils
    flexmock
    psycopg2
    psycopg2cffi
    pg8000
    pytz
    python-dateutil
    pymysql
    pyodbc
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies)
    ++ lib.optionals (pythonOlder "3.9") [ backports-zoneinfo ];

  pytestFlagsArray = [
    "--deselect tests/functions/test_database.py::TestDatabasePostgresCreateDatabaseCloseConnection::test_create_database_twice"
    "--deselect tests/functions/test_database.py::TestDatabasePostgresPg8000::test_create_and_drop"
    "--deselect tests/functions/test_database.py::TestDatabasePostgresPsycoPG2CFFI::test_create_and_drop"
  ];

  meta = with lib; {
    changelog =
      "https://github.com/kvesteri/sqlalchemy-utils/releases/tag/${version}";
    homepage = "https://github.com/kvesteri/sqlalchemy-utils";
    description = "Various utility functions and datatypes for SQLAlchemy";
    license = licenses.bsd3;
  };
}
