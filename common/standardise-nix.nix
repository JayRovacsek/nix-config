{ self }:
let
  inherit (self.common) package-sets;
in
builtins.mapAttrs (
  name: value:
  let
    inherit (value) lib;

    inherit (value.stdenv) isDarwin;

    isUnstable = lib.hasSuffix "unstable" name;
    isBleedingEdge = lib.hasSuffix "bleeding-edge" name;
    isStable = !isUnstable && !isBleedingEdge;

  in
  {
    imports = [ ../options/modules/nix ];

    # The below options should be suitable mappings of input 
    # nixpkgs versions. In my case I utilise stable, unstable and 
    # bleeding-edge / master for various reasons.
    # 
    # If you utilise this code, remember to ensure
    # your inputs are mapped correctly :)
    #
    # Note that unstable, stable and bleeding edge
    # are mutually exclusive - only one can and should exist.
    # The nixPath value and etc softlinks will either:
    # * not work (etc won't be happy with multiple definitions for the
    # same location)
    # OR
    # * utilise only the first nixpkgs input (likely lexicographical order) 
    #
    nix.sources =
      (lib.optionals isBleedingEdge [
        {
          name = "nixpkgs";
          source = self.inputs.bleeding-edge;
        }
      ])
      ++ (lib.optionals isUnstable [
        {
          name = "nixpkgs";
          source = self.inputs.nixpkgs;
        }
      ])
      ++ (lib.optionals isStable [
        {
          name = "nixpkgs";
          source = self.inputs.stable;
        }
      ])
      ++ (lib.optionals isDarwin [
        {
          name = "darwin";
          source = self.inputs.nix-darwin;
        }
        {
          name = "darwin-config";
          source = self;
        }
      ]);
  }

) package-sets
