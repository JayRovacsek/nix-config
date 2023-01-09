{ self }: {
  age = import ./age.nix { inherit self; };
  base-users = import ./base-users.nix { inherit self; };
  desktop = import ./desktop.nix { inherit self; };
  home-manager = import ./home-manager.nix { inherit self; };
  home-manager-modules = import ./home-manager-modules.nix { inherit self; };
  images = import ./images { inherit self; };
  modules = import ./modules.nix { inherit self; };
  options = import ./options.nix;
  package-sets = import ./package-sets.nix { inherit self; };
  pre-commit-unsupported = import ./pre-commit-unsupported.nix;
  system = import ./system.nix { inherit self; };
  standardise-nix = import ./standardise-nix.nix { inherit self; };
  self-reference = import ./self-reference.nix { inherit self; };
  users = import ./users.nix { inherit self; };
}
