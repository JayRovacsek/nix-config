{ self, ... }:
let
  inherit (self.common.terraform.globals) github;
  inherit (self.lib.github)
    generate-public-repositories generate-private-repositories;

  inherit (github) public-repositories private-repositories;

  public-repositories-resources =
    generate-public-repositories public-repositories;
  private-repositories-resources =
    generate-private-repositories private-repositories;

  github_repository = public-repositories-resources
    // private-repositories-resources;

  name = "github";
in {
  variable.GITHUB_TOKEN = {
    type = "string";
    description = "Github Token";
    nullable = false;
    sensitive = true;
  };

  terraform = {
    cloud = {
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

  resource = { inherit github_repository; };
}
