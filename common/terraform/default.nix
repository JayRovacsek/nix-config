{ self }: {
  globals = {
    aws = import ./github.nix { inherit self; };
    github = import ./github.nix { inherit self; };
    oci = import ./oci.nix { inherit self; };
  };
}
