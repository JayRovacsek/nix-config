{ self, pkgs }:
let
  inherit (pkgs) coreutils git;
  inherit (self.lib.hydra) generate-spec;

  # Hard-coding dragonite here kinda sucks - TODO: figure how to
  # dynamically approach this in the future to make this painless 
  # across any hosts required
  spec = builtins.toFile "spec.json" (
    builtins.toJSON (generate-spec self.nixosConfigurations.dragonite)
  );

  program = builtins.toString (
    pkgs.writers.writeBash "generate-spec" ''
      ${coreutils}/bin/mkdir -p ./static/
      ${coreutils}/bin/cp ${spec} ./hydra/spec.json
      ${git}/bin/git add ./hydra/spec.json
    ''
  );

  type = "app";

in
{
  generate-hydra-specification = {
    inherit program type;
  };
}
