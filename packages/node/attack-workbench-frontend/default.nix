{ lib, fetchFromGitHub, buildNpmPackage, nodejs }:
let
  pname = "attack-workbench-frontend";
  version = "2.1.0";

  meta = with lib; {
    homepage =
      "https://github.com/center-for-threat-informed-defense/attack-workbench-frontend";
    description =
      " An application allowing users to explore, create, annotate, and share extensions of the MITRE ATT&CK® knowledge base. This repository contains an Angular-based web application providing the user interface for the ATT&CK Workbench application.";
    license = licenses.asl20;
  };

  src = fetchFromGitHub {
    owner = "center-for-threat-informed-defense";
    repo = "attack-workbench-frontend";
    rev = "v${version}";
    hash = "sha256-p0KuXtizDuBF5omoY7ypQ66HBpuMPEdhb+R3P3A8nI0=";
  };

  sourceRoot = "app";

  npmDepsHash = lib.fakeHash;

in buildNpmPackage {
  inherit pname version src meta nodejs npmDepsHash sourceRoot;
}
