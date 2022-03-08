{ users, ... }:
let
  userFunction = import ./user.nix;
  mappedUsers = builtins.map (x: userFunction { userConfig = x; }) users;
in { users = builtins.foldl' (x: y: x // y) { } mappedUsers; }
