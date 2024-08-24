{ self }:
{
  globals = {
    aws = import ./aws.nix { inherit self; };
    github = import ./github.nix { inherit self; };
    oci = import ./oci.nix { inherit self; };
  };
}
