{ self }:
let
  inherit (self.inputs.nixpkgs) lib;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.strings) concatLines;
  to-css = attrs:
    concatLines (mapAttrsToList (name: value:
      if (builtins.typeOf value == "set") then ''
        ${name} {
          ${self.lib.generators.to-css value}
        }
      '' else
        "${name}: ${builtins.toString value};") attrs);

  # TODO: handle arrays
  to-xml = attrs:
    concatLines (mapAttrsToList (name: value:
      if (builtins.typeOf value == "set") then ''
        <${name}>${self.lib.generators.to-xml value}</${name}>
      '' else
        "<${name}>${builtins.toString value}</${name}>") attrs);

in { inherit to-css to-xml; }
