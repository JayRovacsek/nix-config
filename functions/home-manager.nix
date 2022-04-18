{ home-manager, host, overrides ? { }, ... }:
let
  systemUsers = import ../hosts/${host}/users.nix;
  mappedUsers = builtins.map (x: {
    # nixfmt hates the below. But it is valid.
    "${x.name}" = { imports = [ ../hosts/${host}/user-modules.nix ]; };
  }) systemUsers;
  users = builtins.foldl' (x: y: x // y) { } mappedUsers;
in [
  ../hosts/${host}
  home-manager.nixosModules.home-manager
  {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users = users;
  }
]
