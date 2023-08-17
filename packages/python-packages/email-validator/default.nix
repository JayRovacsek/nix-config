{ lib, python, fetchFromGitHub, ... }:

let inherit (python) buildPythonPackage dnspython idna pythonOlder;

in buildPythonPackage rec {
  pname = "email-validator";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "JoshData";
    repo = "python-${pname}";
    rev = "refs/tags/v${version}";
    hash = "sha256-o7UREa+IBiFjmqx0p+4XJCcoHQ/R6r2RtoezEcWvgbg=";
  };

  propagatedBuildInputs = [ dnspython idna ];

  doCheck = false;

  meta = with lib; {
    description = "Email syntax and deliverability validation library";
    homepage = "https://github.com/JoshData/python-email-validator";
    changelog =
      "https://github.com/JoshData/python-email-validator/releases/tag/v${version}";
    license = licenses.cc0;
    maintainers = with maintainers; [ siddharthist ];
  };
}
