{ self, ... }:
let
  inherit (self.common.terraform.globals) github;
  name = "github";

  default-settings = {
    allow_auto_merge = true;
    allow_merge_commit = true;
    allow_rebase_merge = true;
    allow_squash_merge = true;
    allow_update_branch = true;
    archive_on_destroy = false;
    auto_init = true;
    delete_branch_on_merge = true;
    has_discussions = false;
    has_downloads = false;
    has_issues = true;
    has_projects = false;
    has_wiki = false;
    is_template = false;
    merge_commit_message = "PR_TITLE";
    merge_commit_title = "MERGE_MESSAGE";
    squash_merge_commit_message = "COMMIT_MESSAGES";
    squash_merge_commit_title = "COMMIT_OR_PR_TITLE";
    vulnerability_alerts = true;
  };

  # TODO: move some functions to lib.
  generate-repo = repo: overrides:
    let resource-name = builtins.replaceStrings [ "." ] [ "-" ] repo.name;
    in { "${resource-name}" = default-settings // overrides // repo; };

  public-repository-settings = {
    visibility = "public";
    security_and_analysis = {
      advanced_security.status = "enabled";
      secret_scanning.status = "enabled";
      secret_scanning_push_protection.status = "enabled";
    };
  };

  public-archive-repository-settings = {
    visibility = "public";
    archived = true;
  };

  private-repository-settings.visibility = "private";

  public-repository = repo: generate-repo repo public-repository-settings;
  public-archived-repository = repo:
    generate-repo repo public-archive-repository-settings;
  private-repository = repo: generate-repo repo private-repository-settings;

  inherit (github)
    public-repositories public-archived-repositories private-repositories;

  public-repo-resources =
    builtins.foldl' (accumulator: repo: (public-repository repo) // accumulator)
    { } public-repositories;

  public-archived-repo-resources = builtins.foldl'
    (accumulator: repo: (public-archived-repository repo) // accumulator) { }
    public-archived-repositories;

  private-repo-resources = builtins.foldl'
    (accumulator: repo: (private-repository repo) // accumulator) { }
    private-repositories;

  github_repository = public-repo-resources // public-archived-repo-resources
    // private-repo-resources;

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
