{
  pkgs,
  findutils,
  coreutils,
  gnused,
  ...
}:
pkgs.stdenv.mkDerivation {
  name = "wshobson-agents";
  src = pkgs.fetchFromGitHub {
    owner = "wshobson";
    repo = "agents";
    rev = "0818067b4ecad18c234b2ae427cc44f2053792d4";
    hash = "sha256-gFYaNc3fX4u7ifPbXnao49b/9ejxgq5VldVPEdCQ4tg=";
  };
  patchPhase = ''
    find . -name '*.md' -type f -exec ${gnused}/bin/sed -i '/^model: /d' {} +
  '';

  installPhase = ''
    ${coreutils}/bin/mkdir -p \
      "$out/share/agents" \
      "$out/share/skills" \
      "$out/share/commands"

    ${findutils}/bin/find $src -type d \( \
        -name agents -o \
        -name skills -o \
        -name commands \
      \) | while read -r dir; do

      kind="$(${coreutils}/bin/basename "$dir")"

      echo "Installing $dir -> $out/share/$kind"

      ${coreutils}/bin/cp -rn "$dir/." "$out/share/$kind/"
    done
  '';
}
