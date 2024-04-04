{ lib, fetchFromGitHub, buildDotnetModule, dotnet-runtime }:
let
  pname = "battlenet-lancache-prefill";
  version = "1.7.0";

  meta = with lib; {
    homepage = "https://github.com/tpill90/battlenet-lancache-prefill";
    description =
      "CLI tool to automatically prefill a Lancache with Battle.Net games";
    license = licenses.mit;
    inherit (dotnet-runtime.meta) platforms;
  };

  src = fetchFromGitHub {
    owner = "tpill90";
    repo = "battlenet-lancache-prefill";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-qQjqNiZk7m38AR23pVp963ZO+GECcdWkxA4i9+8Lt+I=";
  };

  patches = [ ./no-appcontext.patch ];

  projectFile = [
    "BattleNetPrefill/BattleNetPrefill.csproj"
    "LancachePrefill.Common/LancachePrefill.Common.csproj"
  ];

  nugetDeps = ./deps.nix;

in buildDotnetModule {
  inherit pname version meta src dotnet-runtime patches projectFile nugetDeps;
}
