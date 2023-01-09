{ self }: {
  cli = import ./cli.nix { inherit self; };
  desktop = import ./desktop.nix { inherit self; };
}
