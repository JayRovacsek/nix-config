{ self, ... }:
let
  inherit (self.common.tofu.globals) github;
  inherit (self.lib.github)
    generate-public-repositories generate-private-repositories
    generate-default-branch-rules;

  inherit (github) public-repositories private-repositories;

  public-repositories-resources =
    generate-public-repositories public-repositories;
  private-repositories-resources =
    generate-private-repositories private-repositories;

  github_repository = public-repositories-resources
    // private-repositories-resources;

  name = "github";

  active-public-repositories =
    builtins.filter (x: !(builtins.hasAttr "archived" x) || !x.archived)
    public-repositories;

  github_branch_default =
    generate-default-branch-rules active-public-repositories;
in {
  variable.GITHUB_TOKEN = {
    type = "string";
    description = "Github Token";
    nullable = false;
    sensitive = true;
  };

  terraform = {
    cloud = {
      hostname = "app.terraform.io";
      organization = "TSvY5rCj9RAYyz4z2W7JZ5VwY2ec9EDg";
      workspaces = { inherit name; };
    };
    required_providers = {
      github = {
        source = "integrations/github";
        version = "~> 5.0";
      };
    };
  };

  provider.github = {
    owner = "JayRovacsek";
    token = "\${var.GITHUB_TOKEN}";
  };

  resource = { inherit github_repository github_branch_default; };
}
