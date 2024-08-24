{ self }:
let
  inherit (self.inputs.nixpkgs) lib;
  inherit (lib.strings) optionalString;
in
{
  generate-monitors = builtins.map (
    m:
    "${m.name},${m.resolution},${m.position},${m.scale}${
      optionalString (m.extra != "") ",${m.extra}"
    }"
  );
}
