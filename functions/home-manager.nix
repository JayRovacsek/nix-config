{ home-manager, hostname, isLinux ? true, extraModules ? [ ], self, ... }:
let
  systemUsers = import ../hosts/${hostname}/users.nix {
    config = if isLinux then
      self.nixosConfigurations."${hostname}".config
    else
      self.darwinConfigurations."${hostname}".config;
    pkgs = if isLinux then
      self.nixosConfigurations."${hostname}".pkgs
    else
      self.darwinConfigurations."${hostname}".pkgs;
    flake = self;
  };
  stateVersion = {
    stateVersion = if isLinux then
      self.nixosConfigurations."${hostname}".config.system.stateVersion
    else
      self.darwinConfigurations."${hostname}".config.system.nixpkgsRelease;
  };
  mappedUsers = builtins.map (x: {
    "${x.name}" = {
      imports = [ ../hosts/${hostname}/user-modules.nix ];
      xdg.configFile."nix/inputs/nixpkgs".source = self.inputs.nixpkgs.outPath;
      home = if (builtins.hasAttr "homeManagerConfig" x) then
        x.homeManagerConfig // stateVersion
      else
        stateVersion;
    };
  }) (builtins.filter (y:
    if builtins.hasAttr "isNormalUser" y then
      (y.isNormalUser && y.name != "builder")
    else
      isLinux == false) systemUsers);
  users = builtins.foldl' (x: y: x // y) { } mappedUsers;
  # Configs are generated either for linux systems or for darwin
  cfg = if isLinux then [
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
in cfg ++ extraModules
