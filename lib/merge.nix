{ self }:
let inherit (self.inputs.nixpkgs.lib) recursiveUpdate;
in builtins.foldl' recursiveUpdate { }
