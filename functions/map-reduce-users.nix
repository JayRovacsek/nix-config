{ userConfigs }:
let
  mappedUsers =
    builtins.map (x: import ./user.nix { userConfig = x; }) userConfigs;
in { users = builtins.foldl' (x: y: x // y) { } mappedUsers; }
