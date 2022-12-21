{ self }: {
  users = import ./users.nix { inherit self; };
  base-users = import ./base-users.nix { inherit self; };
}
