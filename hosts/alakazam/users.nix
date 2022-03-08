let
  jay = import ../../users/standard/jay.nix;
  test = import ../../users/standard/test.nix;
in { users = [ jay test ]; }
