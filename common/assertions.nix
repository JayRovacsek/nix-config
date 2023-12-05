{ self }:
let inherit (self.inputs.nixpkgs) lib;
in { disable-assertions = { assertions = lib.mkForce [ ]; }; }
