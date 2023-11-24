{ self }:
let
  inherit (self.inputs.nixpkgs) lib;
  inherit (lib) foldl' optionalString;

  xml-header = ''<?xml version="1.0" encoding="utf-8"?>'';

  to-xml-string = { name, children ? null, props ? null, ... }:
    if children == null then
      "<${name}${optionalString (props != null) " ${props}"} />"
    else
      "<${name}${optionalString (props != null) " ${props}"}>${
        if builtins.typeOf children == "list" then
          (foldl' (acc: x: "${acc}${to-xml-string x}") "" children)
        else
          builtins.toString children
      }</${name}>";

  to-basic-xml = x: ''
    ${xml-header}
    ${to-xml-string x}
  '';
in { inherit to-basic-xml; }
