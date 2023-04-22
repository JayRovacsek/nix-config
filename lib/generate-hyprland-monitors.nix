{ self }:
let
  inherit (self.inputs.nixpkgs) lib;
  inherit (lib.strings) concatMapStringsSep optionalString;

  fn = concatMapStringsSep "\n" (m:
    "monitor=${m.name},${m.resolution},${m.position},${m.scale}${
      optionalString (m.extra != "") ",${m.extra}"
    }");
in fn
