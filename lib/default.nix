{ self }: {
  generate-user-config = import ./generate-user-config.nix { inherit self; };
  generate-user-configs = import ./generate-user-configs.nix { inherit self; };
  generate-home-manager-config =
    import ./generate-home-manager-config.nix { inherit self; };
  generate-home-manager-configs =
    import ./generate-home-manager-configs.nix { inherit self; };
  home-manager-modules = import ./home-manager-modules.nix { inherit self; };
  users = import ./users.nix { inherit self; };
}
