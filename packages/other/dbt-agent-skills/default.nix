{ pkgs, ... }:
let
  src = pkgs.fetchFromGitHub {
    owner = "dbt-labs";
    repo = "dbt-agent-skills";
    rev = "59aa1faf061d288e76044de0bee74248b0399a55";
    hash = "sha256-wszrCm1PefAUKjWuClPBWr6ZvSOwakmfAKVR4ueuxVc=";
  };
in
pkgs.stdenv.mkDerivation {
  name = "dbt-agent-skills";
  inherit src;
  postPatch = ''
    find . -name '*.md' -type f -exec ${pkgs.gnused}/bin/sed -i '/^user-invocable: /d' {} +
  '';
  installPhase = ''
    mkdir -p $out/share/skills
    cp -rT skills $out/share/skills
  '';
}
