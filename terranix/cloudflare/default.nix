{ self, ... }:
let
  inherit (self.common.terraform.globals) cloudflare;
  inherit (self.lib.terraform) tfvar;
  name = "cloudflare";
in rec {
  variable = {
    CLOUDFLARE_API_TOKEN_CREATE = {
      type = "string";
      description = "Cloudflare token that can create other tokens";
      nullable = false;
      sensitive = true;
    };
  };

  terraform = {
    cloud = {
      organization = "TSvY5rCj9RAYyz4z2W7JZ5VwY2ec9EDg";
      workspaces = { inherit name; };
    };
    required_providers = {
      cloudflare = {
        source = "cloudflare/cloudflare";
        version = "4.9.0";
      };
    };
  };

  data.cloudflare_api_token_permission_groups.all = { };

  provider.cloudflare.api_token = tfvar "CLOUDFLARE_API_TOKEN_CREATE";

  resource = {
    cloudflare_zone = {
      rovacsek = {
        account_id = "2f9533403f3018832e20b68b23b81277";
        zone = "rovacsek.com";
      };
    };
  };
}
