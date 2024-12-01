{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnet-runtime_8,
  dotnet-sdk_8,
}:
let
  dotnet-runtime = dotnet-runtime_8;
  dotnet-sdk = dotnet-sdk_8;
  pname = "battlenet-lancache-prefill";
  version = "2.1.0";

  meta = with lib; {
    homepage = "https://github.com/tpill90/battlenet-lancache-prefill";
    description = "CLI tool to automatically prefill a Lancache with Battle.Net games";
    license = licenses.mit;
    inherit (dotnet-runtime.meta) platforms;
  };

  src = fetchFromGitHub {
    owner = "tpill90";
    repo = "battlenet-lancache-prefill";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-AkYZfalhl5Mmx0DJVuwQnRhhNkYS+AFCsnfmlMFSNS4=";
  };

  patches = [ ./no-appcontext.patch ];

  projectFile = [
    "BattleNetPrefill/BattleNetPrefill.csproj"
    "LancachePrefill.Common/dotnet/LancachePrefill.Common.csproj"
  ];

  nugetDeps = ./deps.nix;

in
buildDotnetModule {
  inherit
    pname
    version
    meta
    src
    dotnet-runtime
    dotnet-sdk
    patches
    projectFile
    nugetDeps
    ;
}
