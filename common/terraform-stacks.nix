{ self }:
let
  stacks = builtins.attrNames (builtins.readDir ../packages/terranix);
  cfg = builtins.foldl' (accumulator: stack:
    {
      ${stack} = import ../packages/terranix/${stack} { inherit self; };
    } // accumulator) { } stacks;
in cfg
