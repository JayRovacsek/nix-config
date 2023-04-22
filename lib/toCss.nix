{ self }:
let
  inherit (self.inputs.nixpkgs) lib;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.strings) concatLines;
in attrs:
concatLines (mapAttrsToList (name: value:
  if (builtins.typeOf value == "set") then ''
    ${name} {
      ${self.lib.toCss value}
    }
  '' else
    "${name}: ${builtins.toString value};") attrs)
