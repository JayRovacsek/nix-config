{ userConfigs, pkgs, ... }:
let
  userFunction = import ./user.nix;
  mappedUsers = builtins.map (x:
    userFunction {
      inherit pkgs;
      userConfig = x;
    }) userConfigs;
in { users = builtins.foldl' (x: y: x // y) { } mappedUsers; }
