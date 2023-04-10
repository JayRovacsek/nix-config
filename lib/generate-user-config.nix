_:
let
  fn = { flake, config, pkgs, user-settings, modules, stable ? false
    , overrides ? { }, ... }:
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
      inherit (stdenv) isLinux;
      inherit (user-settings) name;
      inherit (lib) recursiveUpdate;
      inherit (lib.strings) hasInfix;
      inherit (lib.attrsets) filterAttrs;
      inherit (flake.inputs) home-manager;
      inherit (flake.common) user-attr-names;

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
      identityFiles =
        concatStringsSep "\n  " (map (x: "IdentityFile ${x.path}") sshKeys);

      # Pull the localdomain on the configured machine, as I have added an extra configuration
      # option for machines of "localDomain"
      localDomain = if hasAttr "localDomain" config.networking then
        config.networking.localDomain
      else
        config.networking.domain;

      darwinHosts = if hasAttr "darwinConfigurations" flake then
        attrNames flake.darwinConfigurations
      else
        [ ];

      linuxHosts = if hasAttr "nixosConfigurations" flake then
        attrNames flake.nixosConfigurations
      else
        [ ];

      addKeys = "AddKeysToAgent yes";
      forwardAgent = "ForwardAgent yes";
      addKeysForwardAgent = ''
        ${addKeys}
          ${forwardAgent}'';

      extraHostNames = darwinHosts ++ linuxHosts;

      requireBuilderConfigs = (hasAttr "builder" config.users.users)
        && (hasAttr "builder-id-ed25519" config.age.secrets);

      # So for the longest time, I couldn't figure why distributed builds didn't work.
      # Turns out it was likely because I was configuring the ssh config wrong leading to 
      extraHostConfigs = if requireBuilderConfigs then
        (map (hostName: ''
          Host builder_${hostName}
            HostName ${hostName}
            User builder
            ${addKeysForwardAgent}
            IdentityFile ${config.age.secrets.builder-id-ed25519.path}

          Host ${name}_${hostName}
            HostName ${hostName}
            User ${name}
            ${addKeysForwardAgent}
            ${if ((length sshKeys) != 0) then identityFiles else ""}
        '') extraHostNames)
      else
        map (hostName: ''
          Host ${hostName}
            HostName ${hostName}
            ${addKeysForwardAgent}
            ${if ((length sshKeys) != 0) then identityFiles else ""}
        '') extraHostNames;

      # This will pin nixpkgs in a user context to whatever
      # the system nixpkgs version is - assuming it is set to
      # be available as xdg.configHome
      defaultHome = {
        # State version here is the database layout NOT the packages version or 
        # associated settings.
        stateVersion = "22.11";

        sessionVariables.NIX_PATH = "nixpkgs=${
            config.home-manager.users."${name}".xdg.configHome
          }/nix/inputs/nixpkgs\${NIX_PATH:+:$NIX_PATH}";

        file.".ssh/config".text = ''
          Host github.com
            HostName github.com
            User git
            ${addKeys}
            ${if ((length sshKeys) != 0) then identityFiles else ""}

          Host *.rovacsek.com.internal
            ${addKeysForwardAgent}
            ${if ((length sshKeys) != 0) then identityFiles else ""}

          ${if localDomain == null then
            ""
          else ''
            Host *.${localDomain}
              ${addKeysForwardAgent}
              ${if ((length sshKeys) != 0) then identityFiles else ""}''}

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
      users.users.${name} =
        recursiveUpdate { shell = pkgs.zsh; } stripped-user-settings;

      home-manager.users.${name} = {
        home = recursiveUpdate defaultHome optionalHome;
        inherit accounts;
        imports = modules;
        xdg.configFile."nix/inputs/nixpkgs".source = nixpkgs.outPath;
      };
    };
in fn
