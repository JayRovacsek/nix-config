{ self }: {
  generate-user-config = import ./generate-user-config.nix { inherit self; };
  standardise-nix = import ./standardise-nix.nix { inherit self; };
  home-manager = import ./home-manager.nix { inherit self; };
}
