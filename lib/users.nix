_:
let
  generate-config = { flake, config, pkgs, user-settings, modules
    , stable ? false, overrides ? { }, ... }:
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
      inherit (stdenv) isLinux isDarwin;
      inherit (user-settings) name;
      inherit (lib) recursiveUpdate;
      inherit (lib.strings) hasInfix;
      inherit (lib.attrsets) filterAttrs;
      inherit (flake.inputs) home-manager;
      inherit (flake.common) user-attr-names;
      inherit (flake.lib.ssh) generate-ssh-config;

      # Also described below, making the recursive update easier to follow
      flippedRecursiveUpdate = x: y: recursiveUpdate y x;

      home = if isLinux then "/home/${name}" else "/Users/${name}";

      # For the configuration we're applying to; check if agenix is present
      # if it is we filter the associated secrets for that of our username-id-ed25519
      # and if present assume these are our authorised keys to be applied in identity files
      sshKeys = if (hasAttr "secrets" config.age) then
        (filter (x: hasInfix "${name}-id-ed25519" x.name)
          (attrValues config.age.secrets))
      else
        [ ];

      # Create a string that represents the ssh keys we identified as loaded into agenix above
      # to be utilised per known host in our configuration
      identity-files = if (length sshKeys != 0) then
        concatStringsSep "\n  " (map (x: "IdentityFile ${x.path}") sshKeys)
      else
        "";

      extraHostConfigs = generate-ssh-config name identity-files;

      # This will pin nixpkgs in a user context to whatever
      # the system nixpkgs version is - assuming it is set to
      # be available as xdg.configHome
      defaultHome = {
        # State version here is the database layout NOT the packages version or 
        # associated settings.
        stateVersion = "22.11";

        sessionVariables.NIX_PATH = "nixpkgs=${builtins.toString pkgs.path}";

        file.".ssh/config".text = ''
          Host github.com
            HostName github.com
            User git
            AddKeysToAgent yes
            ${if ((length sshKeys) != 0) then identity-files else ""}

          ${concatStringsSep "\n\n" extraHostConfigs}
        '';
      };

      stripped-user-settings =
        filterAttrs (name: _: elem name user-attr-names) user-settings;

      nixpkgs = if stable then flake.inputs.stable else flake.inputs.nixpkgs;

      optionalHome = lib.attrsets.optionalAttrs (hasAttr "home" user-settings)
        user-settings.home;
      accounts = lib.attrsets.optionalAttrs (hasAttr "accounts" user-settings)
        user-settings.accounts;

      # Inverting the logic on recursive update here to increase readability: otherwise 
      # overrides would need to follow the base config leading to it hiding at the end of
      # this file.
    in flippedRecursiveUpdate overrides {
      users.users.${name} = recursiveUpdate {
        shell = if name != "builder" then pkgs.zsh else pkgs.bash;
        home = if isDarwin then "/Users/${name}" else "/home/${name}";
      } stripped-user-settings;

      home-manager.users.${name} = {
        home = recursiveUpdate defaultHome optionalHome;
        inherit accounts;
        imports = modules;
        xdg.configFile."nix/inputs/nixpkgs".source = nixpkgs.outPath;
      };
    };

  # TODO: clean up the below - it's old as heck and
  # makes me sad.
  generate-service-user = cfg:
    let
      extraGroupExtendedOptions =
        if cfg.name == cfg.group.name then { } else { "${cfg.name}" = { }; };
    in {
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
        "${cfg.group.name}" = { inherit (cfg.group) gid members; };
      } // extraGroupExtendedOptions;
    };
in { inherit generate-config generate-service-user; }
