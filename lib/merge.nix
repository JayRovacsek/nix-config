{ self }:
let inherit (self.inputs.stable.lib) recursiveUpdate;
in builtins.foldl' recursiveUpdate { }
