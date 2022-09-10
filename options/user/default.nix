{ lib, ... }:
with lib;
with types; {
  options.users.users = mkOption {
    type = attrsOf (submodule ({ ... }: {
      options = {
        home-manager-modules = mkOption {
          type = attrsOf (submodule ({ config, ... }: {
            # TODO: have both string and settings options so
            # we can make settings maps per user
            options.homeManagerModules = mkOption {
              type = listOf str;
              default = [ ];
            };
          }));
        };
      };
    }));
  };
}
