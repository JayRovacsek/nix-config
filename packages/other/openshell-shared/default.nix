# Shared, non-binary content from the OpenShell repository, pinned to the same
# source as the openshell package: https://github.com/NVIDIA/OpenShell
#
# - share/providers: upstream provider profiles with `binaries` stripped, as the
#   upstream paths (/usr/bin/...) never match Nix store paths.
# - share/skills: upstream agent skills.
{
  self,
  pkgs,
  stdenv,
  yq-go,
  ...
}:
let
  inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) openshell;
in
stdenv.mkDerivation {
  pname = "openshell-shared";
  inherit (openshell) version src;

  nativeBuildInputs = [ yq-go ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    ${pkgs.coreutils}/bin/mkdir -p $out/share/providers $out/share/skills

    for file in providers/*.yaml; do
      ${pkgs.yq-go}/bin/yq 'del(.binaries)' "$file" > "$out/share/providers/$(basename "$file")"
    done

    ${pkgs.coreutils}/bin/cp -r skills/. $out/share/skills/
  '';
}
