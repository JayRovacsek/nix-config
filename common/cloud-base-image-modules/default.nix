{ self }: {
  amazon = import ./amazon.nix { inherit self; };
  linode = import ./linode.nix { inherit self; };
  oracle = import ./oracle.nix { inherit self; };
}
