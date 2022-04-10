let
  jay = import ../../users/standard/jay.nix;
  root = import ../../users/standard/root.nix;
in { users = [ jay root ]; }
