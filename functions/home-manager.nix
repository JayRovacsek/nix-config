{ home-manager, hostname, isLinux ? false, extraModules ? [], ... }:
let
  systemUsers = import ../hosts/${hostname}/users.nix;
  mappedUsers = builtins.map (x: {
    # nixfmt hates the below. But it is valid.
    "${x.name}" = { imports = [ ../hosts/${hostname}/user-modules.nix ]; };
  }) systemUsers;
  users = builtins.foldl' (x: y: x // y) { } mappedUsers;
  # Configs are generated either for linux systems or for darwin
  # 
  config = if isLinux then [
  ../hosts/${hostname}
  home-manager.nixosModules.home-manager
  {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users = users;
  }
] else [
  ../hosts/${hostname}
  home-manager.darwinModule
  {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users = users;
  }
];
in config ++ extraModules