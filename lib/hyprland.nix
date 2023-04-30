{ self }:
let
  inherit (self.inputs.nixpkgs) lib;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.strings) concatLines concatMapStringsSep optionalString;
in {
  # Given a nix definition, will generate a suitable hyprland config
  # equivalent.
  # Note this doesn't check for setting availability, instead simply 
  # converts a nix object to a string that matches rules of a hyprland
  # config.
  generate-config = attrs:
    # Apply a transform over all attributes of a config set
    concatLines (mapAttrsToList (name: value:
      # If the attribute is a list, we know this is because the key cannot 
      # exist multiple times as it can in our config.
      # turn each value into a setting against the key.
      # e.g a = [ 1 2 3 ]
      # =
      # a = 1
      # a = 2
      # a = 3
      if (builtins.typeOf value == "list") then
        concatMapStringsSep "\n" (x: "${name}=${x}") value
        # If we are presented a set, then we recursive and encapsulate all children
        # in a set of brackets
      else if (builtins.typeOf value == "set") then ''
        ${name} {
          ${self.lib.hyprland.generate-config value}
        }
      ''
      # If the value is a boolean, we conditionally apply "true/false"
      # as nix handles toString of bool as 1 for true and empty for false :sadpanda:
      else if (builtins.typeOf value == "bool") then
        "${name}=${if value then "true" else "false"};"
      else
        "${name}=${builtins.toString value}") attrs);

  generate-monitors = builtins.map (m:
    "${m.name},${m.resolution},${m.position},${m.scale}${
      optionalString (m.extra != "") ",${m.extra}"
    }");
}
