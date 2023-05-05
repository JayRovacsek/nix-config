_:
let name = "github";
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

  resource = {
    github_repository = {
      dotfiles = {
        name = "dotfiles";
        description = "A repository to manage dotfiles and config";
        #tfsec:ignore:github-repositories-private
        visibility = "public";
        vulnerability_alerts = true;
      };
    };
  };
}
