{ self }: {
  users = import ./users.nix { inherit self; };
  base-users = import ./base-users.nix { inherit self; };
  home-manager-modules = import ./home-manager-modules.nix { inherit self; };
  overlays = import ./overlays.nix;
  packages = import ./packages.nix { inherit self; };
}
