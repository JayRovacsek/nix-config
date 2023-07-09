{ lib, fetchFromGitHub, buildDotnetModule, dotnet-runtime }:
let
  pname = "epic-lancache-prefill";
  version = "1.1.2";

  meta = with lib; {
    homepage = "https://github.com/tpill90/epic-lancache-prefill";
    description =
      "CLI tool to automatically prefill a Lancache with Battle.Net games";
    license = licenses.mit;
    inherit (dotnet-runtime.meta) platforms;
  };

  src = fetchFromGitHub {
    owner = "tpill90";
    repo = "epic-lancache-prefill";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-YvaZ1MDGb2XEs2bh6EdtXIAdXu8YrvBjtuGHNXsmvlM=";
  };

  patches = [ ./no-appcontext.patch ];

  projectFile = [
    "EpicPrefill/EpicPrefill.csproj"
    "LancachePrefill.Common/LancachePrefill.Common.csproj"
  ];

  nugetDeps = ./deps.nix;

in buildDotnetModule {
  inherit pname version meta src dotnet-runtime projectFile nugetDeps patches;
}
