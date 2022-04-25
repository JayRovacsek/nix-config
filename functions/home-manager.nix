{ home-manager, host, isNixos, extraModules ? [], ... }:
let
  systemUsers = import ../hosts/${host}/users.nix;
  mappedUsers = builtins.map (x: {
    # nixfmt hates the below. But it is valid.
    "${x.name}" = { imports = [ ../hosts/${host}/user-modules.nix ]; };
  }) systemUsers;
  users = builtins.foldl' (x: y: x // y) { } mappedUsers;
  # Configs are generated either for linux systems or for darwin
  # 
  config = if isNixos then [
  ../hosts/${host}
  home-manager.nixosModules.home-manager
  {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users = users;
  }
] else [
  ../hosts/${host}
  home-manager.darwinModule
  {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users = users;
  }
];
in config ++ extraModules