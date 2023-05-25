{ self, system }:
let
  pkgs = self.inputs.nixpkgs.legacyPackages.${system};
  inherit (pkgs) coreutils git;
  inherit (self.lib.distributed-builds) base-configs;

  configs =
    builtins.toFile "build-machines.json" (builtins.toJSON base-configs);

  program = builtins.toString (pkgs.writers.writeBash "copy-configs" ''
    ${coreutils}/bin/mkdir -p ./static/
    ${coreutils}/bin/cp ${configs} ./static/build-machines.json
    ${git}/bin/git add ./static/build-machines.json
  '');

  type = "app";

in { generate-distributed-build-configs = { inherit program type; }; }
