{ self }:
let
  inherit (self.inputs.nixpkgs) lib;
  inherit (lib) foldl' optionalString;

  xml-header = ''<?xml version="1.0" encoding="utf-8"?>'';

  bool-to-string = x: if x then "true" else "false";

  to-xml-string = { name, value ? null, props ? null, ... }:
    if value == null then
      "<${name}${optionalString (props != null) " ${props}"} />"
    else
      "<${name}${optionalString (props != null) " ${props}"}>${
        if builtins.typeOf value == "list" then
          (foldl' (acc: x: "${acc}${to-xml-string x}") "" value)
        else if builtins.typeOf value == "bool" then
          bool-to-string value
        else
          builtins.toString value
      }</${name}>";

  to-basic-xml = x: ''
    ${xml-header}
    ${to-xml-string x}
  '';
in { inherit to-basic-xml; }
