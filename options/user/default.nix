{ config, lib, ... }:
with lib;
with types;
let
  cfg = config.users.users;
  hmModuleOption = { config, ... }: {
    options = {
      name = mkOption {
        type = types.str;
        description = "The name of a module to install";
      };
      settings = mkOption {
        type = with types; anything;
        default = { };
        description = ''
          Options to merge into the home manager module per user. These options need to adhere to the home manager options related to the program/setting or an error will occur.
          In the future this will be resolved automatically, dropping attributes that do not belong
        '';
      };
    };
  };

  checkOptionApplied = builtins.any (user: user.homeManagerModules != [ ])
    (builtins.attrValues cfg);

  appliedUsers = if checkOptionApplied then
    builtins.filter (user: user.homeManagerModules != [ ])
    (builtins.attrValues cfg)
  else
    [ ];

  homeManagerModuleFiles = builtins.filter (module:
    builtins.elem "default.nix"
    (builtins.readDir ../../home-manager-modules/${module}))
    (builtins.attrNames (builtins.readDir ../../home-manager-modules));

  hasModuleDefined = module: (builtins.elem module.name homeManagerModuleFiles);

  generatedUserConfigs = builtins.map (user: {
    "${user}" = builtins.map (module: {
      programs."${module.name}" = if (hasModuleDefined module) then
        import ../../home-manager-modules/${module.name}
      else
        { };
    }) user.homeManagerModules;
  }) appliedUsers;

in {
  options.users.users = mkOption {
    type = attrsOf (submodule (_: {
      options = {
        homeManagerModules = mkOption {
          type = with types;
            listOf (coercedTo str (name: { inherit name; })
              (submodule hmModuleOption));
          default = [ ];
        };
      };
    }));
  };

  config =
    mkIf checkOptionApplied { home-manager.users = generatedUserConfigs; };
}
