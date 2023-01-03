{ self }: {
  base-users = import ./base-users.nix { inherit self; };
  home-manager = import ./home-manager.nix { inherit self; };
  home-manager-modules = import ./home-manager-modules.nix { inherit self; };
  modules = import ./modules.nix { inherit self; };
  options = import ./options.nix;
  overlays = import ./overlays.nix;
  package-sets = import ./package-sets.nix { inherit self; };
  system = import ./system.nix { inherit self; };
  standardise-nix = import ./standardise-nix.nix { inherit self; };
  self-reference = import ./self-reference.nix { inherit self; };
  users = import ./users.nix { inherit self; };
}
