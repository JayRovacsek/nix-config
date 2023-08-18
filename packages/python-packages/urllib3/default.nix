{ lib, python, ... }:

let
  inherit (python)
    brotli brotlicffi buildPythonPackage certifi cryptography fetchPypi idna
    isPyPy mock pyopenssl pysocks freezegun pytest-timeout pytestCheckHook
    python-dateutil tornado trustme hatchling pythonOlder;

in buildPythonPackage rec {
  pname = "urllib3";
  version = "2.0.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jSL4aq6O9eQQ1PU5/enOayEToAG7TRieCu1wZC1gKxE=";
  };

  # FIXME: remove backwards compatbility hack
  propagatedBuildInputs = passthru.optional-dependencies.brotli
    ++ passthru.optional-dependencies.socks ++ [ hatchling ];

  nativeCheckInputs = [
    python-dateutil
    mock
    freezegun
    pytest-timeout
    pytestCheckHook
    tornado
    trustme
  ];

  # Tests in urllib3 are mostly timeout-based instead of event-based and
  # are therefore inherently flaky. On your own machine the tests will
  # typically build fine but on a loaded cluster such as Hydra random
  # timeouts will occur.
  #
  # The urllib3 test suite has two different timeouts in their test suite
  # (see `test/__init__.py`):
  # - SHORT_TIMEOUT
  # - LONG_TIMEOUT
  # When CI is in the env LONG_TIMEOUT will be significantly increased.
  # Still failures can occur and for that reason tests are disabled.
  doCheck = false;

  diabled = pythonOlder "3.7";

  preCheck = ''
    export CI # Increases LONG_TIMEOUT
  '';

  pythonImportsCheck = [ "urllib3" ];

  passthru.optional-dependencies = {
    brotli = if isPyPy then [ brotlicffi ] else [ brotli ];
    # Use carefully since pyopenssl is not supported aarch64-darwin
    secure = [ certifi cryptography idna pyopenssl ];
    socks = [ pysocks ];
  };

  meta = with lib; {
    description = "Powerful sanity-friendly HTTP client for Python";
    homepage = "https://github.com/shazow/urllib3";
    changelog =
      "https://github.com/urllib3/urllib3/blob/${version}/CHANGES.rst";
    license = licenses.mit;
  };
}
