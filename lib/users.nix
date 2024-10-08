_:
let
  generate-config =
    {
      self,
      pkgs,
      user-settings,
      modules,
      stable ? false,
      overrides ? { },
      ...
    }:
    # User settings:
    # {
    #   name,
    #   isNormalUser
    #   initialHashedPassword
    #   extraGroups
    #   openssh
    # }
    # Extra modules should host any home-manager modules & associated settings per user
    with builtins;
    let
      inherit (pkgs) lib stdenv;
      inherit (stdenv) isDarwin;
      inherit (user-settings) name;
      inherit (lib) recursiveUpdate;
      inherit (lib.attrsets) filterAttrs;
      inherit (self.common) user-attr-names;

      # Also described below, making the recursive update easier to follow
      flippedRecursiveUpdate = x: y: recursiveUpdate y x;

      # This will pin nixpkgs in a user context to whatever
      # the system nixpkgs version is - assuming it is set to
      # be available as xdg.configHome
      defaultHome = {
        enableNixpkgsReleaseCheck = false;

        # State version here is the database layout NOT the packages version or 
        # associated settings.
        # stateVersion = "22.11";

        sessionVariables.NIX_PATH = "nixpkgs=${builtins.toString pkgs.path}";
      };

      stripped-user-settings = filterAttrs (
        name: _: elem name user-attr-names
      ) user-settings;

      nixpkgs = if stable then self.inputs.stable else self.inputs.nixpkgs;

      optionalHome = lib.attrsets.optionalAttrs (hasAttr "home" user-settings) user-settings.home;

      accounts = lib.attrsets.optionalAttrs (hasAttr "accounts" user-settings) user-settings.accounts;

    in
    # Inverting the logic on recursive update here to increase readability: otherwise 
    # overrides would need to follow the base config leading to it hiding at the end of
    # this file.
    flippedRecursiveUpdate overrides {
      users.users.${name} = recursiveUpdate {
        shell = pkgs.bash;
        home = if isDarwin then "/Users/${name}" else "/home/${name}";
      } stripped-user-settings;

      home-manager = {
        extraSpecialArgs = {
          inherit self;
        };

        users.${name} = {
          home = recursiveUpdate defaultHome optionalHome;
          inherit accounts;
          imports = modules;
          xdg.configFile."nix/inputs/nixpkgs".source = nixpkgs.outPath;
        };
      };
    };

  # TODO: clean up the below - it's old as heck and
  # makes me sad.
  generate-service-user =
    cfg:
    let
      extraGroupExtendedOptions =
        if cfg.name == cfg.group.name then { } else { "${cfg.name}" = { }; };
    in
    {
      extraUsers = {
        "${cfg.name}" = {
          inherit (cfg) uid extraGroups;
          isSystemUser = true;
          createHome = false;
          description = "User account generated for running a specific service";
          group = "${cfg.name}";
        };
      };

      extraGroups = {
        "${cfg.group.name}" = {
          inherit (cfg.group) gid members;
        };
      } // extraGroupExtendedOptions;
    };

in
{
  inherit generate-config generate-service-user;
}
