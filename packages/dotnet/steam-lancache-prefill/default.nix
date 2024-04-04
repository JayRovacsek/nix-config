{ lib, fetchFromGitHub, buildDotnetModule, dotnet-runtime_8, dotnet-sdk_8 }:
let
  dotnet-runtime = dotnet-runtime_8;
  dotnet-sdk = dotnet-sdk_8;
  pname = "steam-lancache-prefill";
  version = "2.5.0";

  meta = with lib; {
    homepage = "https://github.com/tpill90/steam-lancache-prefill";
    description = "CLI tool to automatically prime a Lancache with Steam games";
    license = licenses.mit;
    inherit (dotnet-runtime_8.meta) platforms;
  };

  src = fetchFromGitHub {
    owner = "tpill90";
    repo = "steam-lancache-prefill";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-DZrvo5k+brRLRhQN7dp+2aEtwaJTW0hKZVoh+eguURw=";
  };

  patches = [ ./no-appcontext.patch ];

  projectFile = [
    "SteamPrefill/SteamPrefill.csproj"
    "LancachePrefill.Common/dotnet/LancachePrefill.Common.csproj"
  ];

  nugetDeps = ./deps.nix;

in buildDotnetModule {
  inherit pname version meta src dotnet-runtime dotnet-sdk projectFile nugetDeps
    patches;
}
