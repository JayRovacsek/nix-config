{ self, pkgs }:
let
  inherit (pkgs) coreutils git;
  inherit (self.lib.distributed-builds) base-configs;

  configs = builtins.toFile "build-machines.json" (builtins.toJSON base-configs);

  program = builtins.toString (
    pkgs.writers.writeBash "copy-configs" ''
      ${coreutils}/bin/mkdir -p ./modules/remote-builds/
      ${coreutils}/bin/cp ${configs} ./modules/remote-builds/build-machines.json
      ${git}/bin/git add ./modules/remote-builds/build-machines.json
    ''
  );

  type = "app";

in
{
  generate-distributed-build-configs = {
    inherit program type;
  };
}
