{ self }:
let
  inherit (self.inputs.nixpkgs) lib;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.strings) concatLines;
  inherit (lib) foldl' optionalString;

  bool-to-string = x: if x then "true" else "false";

  to-css = attrs:
    concatLines (mapAttrsToList (name: value:
      if (builtins.typeOf value == "set") then ''
        ${name} {
          ${to-css value}
        }
      '' else if (builtins.typeOf value == "list") then
        builtins.concatStringsSep "\n" (builtins.map (v: "${name} ${v}") value)
      else
        "${name}: ${builtins.toString value};") attrs);

  to-xml = { name, value ? null, props ? null, include-header ? false, ... }: ''
    ${lib.optionalString include-header
    ''<?xml version="1.0" encoding="utf-8"?>''}
    ${if value == null then
      "<${name}${optionalString (props != null) " ${props}"} />"
    else
      "<${name}${optionalString (props != null) " ${props}"}>${
        if builtins.typeOf value == "list" then
          (foldl' (acc: x: "${acc}${to-xml x}") "" value)
        else if builtins.typeOf value == "bool" then
          bool-to-string value
        else
          builtins.toString value
      }</${name}>"}
  '';

in { inherit to-css to-xml; }
