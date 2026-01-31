{ lib, ... }:
{
  options.age = {
    secrets = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            path = lib.mkOption { type = lib.types.path; };
            file = lib.mkOption { type = lib.types.path; };
            owner = lib.mkOption {
              type = lib.types.str;
              default = "root";
            };
            group = lib.mkOption {
              type = lib.types.str;
              default = "root";
            };
            mode = lib.mkOption {
              type = lib.types.str;
              default = "0400";
            };
            name = lib.mkOption {
              type = lib.types.str;
              default = "secret";
            };
            symlink = lib.mkOption {
              type = lib.types.bool;
              default = true;
            };
          };
        }
      );
      default = { };
    };
    identityPaths = lib.mkOption {
      type = lib.types.listOf lib.types.str; # identityPaths are usually strings or paths
      default = [ ];
    };
  };
}
