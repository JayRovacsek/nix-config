{
  pkgs,
  coreutils,
  findutils,
  gnused,
  fetchFromGitHub,
  ...
}:
pkgs.stdenv.mkDerivation {
  name = "superpowers";
  src = fetchFromGitHub {
    owner = "obra";
    repo = "superpowers";
    rev = "5da4156bdbdcdf98ddf7b7d1931cf9fdc76956e7";
    hash = "sha256-Yq7y6VDrREV60WpfaGsYdnWqoaS7g1hrtci4bGtgtZM=";
  };

  postPatch = ''
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
