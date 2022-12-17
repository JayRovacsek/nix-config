{ self }:
let
  module-function = { config, pkgs, module }:
    let result = module { inherit config pkgs; };
    in result;
in module-function
