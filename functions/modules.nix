{ home-manager, hostname, isLinux ? true, extraModules ? [ ], self, ... }:
let
  stateVersion.stateVersion = "22.05";

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

  standardUsers = builtins.filter (y:
    if builtins.hasAttr "isNormalUser" y then
      (y.isNormalUser && y.name != "builder")
    else
      !isLinux) systemUsers;

  mappedUsers = builtins.map (x: {
    "${x.name}" = {
      manual.manpages.enable = false;
      imports = [ ../hosts/${hostname}/user-modules.nix ];
      ## The below is rather dangeous if not called out:
      # It'll ensure a user NIX_PATH follows the input which may not align with system
      # nixpkgs follow if changed. 
      xdg.configFile."nix/inputs/nixpkgs".source = self.inputs.unstable.outPath;
      home = if (builtins.hasAttr "homeManagerConfig" x) then
        x.homeManagerConfig // stateVersion
      else
        stateVersion;
    };
  }) standardUsers;
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
