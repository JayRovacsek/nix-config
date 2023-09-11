{ lib, fetchFromGitHub, buildDotnetModule, dotnet-runtime, powershell }:
let
  pname = "sharphound";
  version = "2.0.0";

  meta = with lib; {
    homepage = "https://github.com/BloodHoundAD/SharpHound";
    description = "C# Data Collector for BloodHound";
    license = licenses.lgpl3Plus;
    platforms = platforms.windows;
  };

  src = fetchFromGitHub {
    owner = "BloodHoundAD";
    repo = "SharpHound";
    rev = "v${version}";
    hash = "sha256-8+W0agtd5RKDa9QitGnH0K7Kbi/JJ6Ptb/SYGUqVmIo=";
  };

  projectFile = [ "Sharphound.csproj" ];

  nugetDeps = ./deps.nix;

  propagatedBuildInputs = [ powershell ];

  postPatch = ''
    substituteInPlace $src/Sharphound.csproj \
      --replace 'Command="powershell' 'Command="${powershell}/bin/powershell'
  '';

in buildDotnetModule {
  inherit pname version meta src dotnet-runtime projectFile nugetDeps
    propagatedBuildInputs postPatch;
}
