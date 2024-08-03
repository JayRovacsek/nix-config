{ self, ... }:
let
  region = "ap-southeast";
  name = "linode-ami";
in {
  # Piggybacks greatly off the following repositories awesome work: https://github.com/houstdav000/terranix-linode-poc
  # Thank you original author and community for enabling this <3
  variable.LINODE_TOKEN = {
    type = "string";
    description = "Linode API token";
    nullable = false;
    sensitive = true;
  };

  terraform = {
    cloud = {
      hostname = "app.terraform.io";
      organization = "TSvY5rCj9RAYyz4z2W7JZ5VwY2ec9EDg";
      workspaces = { inherit name; };
    };
    required_providers.linode.source = "linode/linode";
  };

  provider.linode.token = "\${ var.LINODE_TOKEN }";

  resource = {
    linode_image.nixos-base = let
      label = "nixos-base";
      description = "Base image generated by nixos-generator";
      file_path = "${self.common.images.linode}/nixos.img.gz";
    in { inherit region label description file_path; };
  };
}
