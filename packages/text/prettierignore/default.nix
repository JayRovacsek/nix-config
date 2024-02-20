{ writeTextFile, ... }:
# Note the below should be injected into location blocks of vhosts
# if authelia is running
writeTextFile {
  name = ".prettierignore";
  text = ''
    .pre-commit-config.yaml
    .prettierignore
    *.nix
    CHANGELOG.md
    result
  '';
}
