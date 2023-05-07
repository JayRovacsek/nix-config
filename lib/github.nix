{ self, ... }:
let
  inherit (self.common.terraform.globals) github;
  inherit (github)
    default-repository-settings public-repository-settings
    private-repository-settings;
  generate-repository = repository: overrides:
    let
      # Replacing periods with hyphens won't always be a solve for terrafrom
      # resource names, but for now it's the only character we need to handle in this
      # space
      resource-name = builtins.replaceStrings [ "." ] [ "-" ] repository.name;
    in {
      "${resource-name}" = default-repository-settings // overrides
        // repository;
    };
  generate-public-repository = repository:
    generate-repository repository public-repository-settings;

  generate-private-repository = repository:
    generate-repository repository private-repository-settings;
in {
  inherit generate-repository generate-public-repository
    generate-private-repository;

  generate-public-repositories = builtins.foldl' (accumulator: repository:
    (generate-public-repository repository) // accumulator) { };

  generate-private-repositories = builtins.foldl' (accumulator: repository:
    (generate-private-repository repository) // accumulator) { };
}
