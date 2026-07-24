{
  coreutils,
  findutils,
  gnused,
  fetchFromGitHub,
  stdenv,
  ...
}:
let
  src = fetchFromGitHub {
    owner = "anthropics";
    repo = "skills";
    rev = "98669c11ca63e9c81c11501e1437e5c47b556621";
    hash = "sha256-w//9LB1OVG9jlllY+VDse7Js0dn5x6Ys2vPuQACKsTM=";
  };
in
stdenv.mkDerivation {
  name = "anthropic-skills";
  inherit src;
  postPatch = ''
    find . -name '*.md' -type f -exec ${gnused}/bin/sed -i '/ALWAYS use `claude-opus-4-6`/d' {} +
    find . -name '*.md' -type f -exec ${gnused}/bin/sed -i '/This is non-negotiable/d' {} +
    find . -name '*.md' -type f -exec ${gnused}/bin/sed -i '/For the Claude model version, please use Claude Opus 4.6/d' {} +
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
