{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cvemap";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-aeUYcgBTHWWLTuAXnnc73yXaC3yLZzruqvedUYCnht4=";
  };

  vendorHash = "sha256-VQGWi01mOP2N4oYsaDK7wn/+hSFEDHhSma9DOZ06Z3k=";

  subPackages = [ "cmd/cvemap/" ];

  doCheck = false;

  meta = with lib; {
    description = "Navigate the CVE jungle with ease.";
    longDescription = ''
      Navigate the Common Vulnerabilities and Exposures (CVE) jungle with ease using CVEMAP, a command-line interface (CLI) tool designed to provide a structured and easily navigable interface to various vulnerability databases.
    '';
    homepage = "https://github.com/projectdiscovery/cvemap";
    changelog =
      "https://github.com/projectdiscovery/cvemap/releases/tag/v${version}";
    license = licenses.mit;
  };
}
