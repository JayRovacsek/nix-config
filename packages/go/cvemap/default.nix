{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cvemap";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-cF9sMcP3m2qZVT/ONovt+JoG+yU9fs8I9Stw01bSwis=";
  };

  vendorHash = "sha256-XS5yHfPfjZpi/PpN/xKVYvpNmkWROKDhqTaDU9v0cOU=";

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
