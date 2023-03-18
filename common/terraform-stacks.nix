{ self }:
let
  stacks = builtins.attrNames (builtins.readDir ../terranix);
  cfg = builtins.foldl' (accumulator: stack:
    {
      ${stack} = import ../terranix/${stack} { inherit self; };
    } // accumulator) { } stacks;
in cfg
