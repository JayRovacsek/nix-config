{ lib, fetchFromGitHub, buildDotnetModule, dotnet-runtime }:
let
  pname = "steam-lancache-prefill";
  version = "2.1.4";

  meta = with lib; {
    homepage = "https://github.com/tpill90/steam-lancache-prefill";
    description = "CLI tool to automatically prime a Lancache with Steam games";
    license = licenses.mit;
    inherit (dotnet-runtime.meta) platforms;
  };

  src = fetchFromGitHub {
    owner = "tpill90";
    repo = "steam-lancache-prefill";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-ZdmPbir2KRSKXtYfn05V9+Y2e8HW4mXhfHlMdVy8oMI=";
  };

  patches = [ ./no-appcontext.patch ];

  projectFile = [
    "SteamPrefill/SteamPrefill.csproj"
    "LancachePrefill.Common/LancachePrefill.Common.csproj"
  ];

  nugetDeps = ./deps.nix;

in buildDotnetModule {
  inherit pname version meta src dotnet-runtime projectFile nugetDeps patches;
}
