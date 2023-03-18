{ self }:
let
  fn = { users }:
    let inherit (self.inputs.stable.lib) recursiveUpdate;
    in builtins.foldl' (accumulator: user: recursiveUpdate user accumulator) { }
    users;
in fn
