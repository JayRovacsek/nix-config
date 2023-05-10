{ self, ... }:
let
  inherit (self.common.terraform.globals) github;
  inherit (github)
    default-repository-settings public-repository-settings
    private-repository-settings;

  # Replacing periods with hyphens won't always be a solve for terrafrom
  # resource names, but for now it's the only character we need to handle in this
  # space
  sanitise-resource-name = builtins.replaceStrings [ "." ] [ "-" ];

  generate-repository = repository: overrides:
    let resource-name = sanitise-resource-name repository.name;
    in {
      "${resource-name}" = default-repository-settings // overrides
        // repository;
    };
  generate-public-repository = repository:
    generate-repository repository public-repository-settings;

  generate-private-repository = repository:
    generate-repository repository private-repository-settings;

  generate-default-branch-rule = repository:
    let resource-name = sanitise-resource-name repository.name;
    in {
      "${resource-name}" = {
        repository = repository.name;
        branch = "main";
        rename = true;
      };
    };

  # TODO: https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_protection
  # generate-default-branch-protection

in {
  inherit generate-repository generate-public-repository
    generate-private-repository generate-default-branch-rule;

  generate-default-branch-rules = builtins.foldl' (accumulator: repository:
    (generate-default-branch-rule repository) // accumulator) { };

  generate-public-repositories = builtins.foldl' (accumulator: repository:
    (generate-public-repository repository) // accumulator) { };

  generate-private-repositories = builtins.foldl' (accumulator: repository:
    (generate-private-repository repository) // accumulator) { };
}
