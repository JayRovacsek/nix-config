{ self, pkgs }:
let
  inherit (pkgs) coreutils;
  inherit (self.lib.distributed-builds) base-configs;

  configs = builtins.toFile "build-machines.json" (builtins.toJSON base-configs);

  program = builtins.toString (
    pkgs.writers.writeBash "copy-configs" ''
      ${coreutils}/bin/mkdir -p ./modules/remote-builds/
      ${coreutils}/bin/cat ${configs} > ./modules/remote-builds/machines.json
      ${pkgs.nodePackages.prettier}/bin/prettier -w ./modules/remote-builds/machines.json
    ''
  );

  type = "app";

in
{
  generate-distributed-build-configs = {
    inherit program type;
  };
}
