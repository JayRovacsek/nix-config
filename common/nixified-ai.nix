{ self }:
let inherit (self.common) package-sets;
in builtins.mapAttrs (package-set: _:
  let
    pkgs = self.common.package-sets.${package-set};
    inherit (pkgs) lib;
    inherit (pkgs.stdenv) isLinux;
    inherit (self.inputs.nixified-ai.nixosModules)
      invokeai-nvidia koboldai-nvidia;
  in { imports = lib.optionals isLinux [ invokeai-nvidia koboldai-nvidia ]; })
package-sets
